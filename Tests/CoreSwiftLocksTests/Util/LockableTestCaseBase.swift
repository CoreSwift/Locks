// -------------------------------------------------------------------------- //
//
// This source file is part of the CoreSwift/Locks open source project.
//
// Copyright (c) 2019 Dynamic Offset, Inc. and the CoreSwift/Locks project
// authors licensed under Apache License v2.0.
//
// See LICENSE for license information.
//
// -------------------------------------------------------------------------- //

import CoreSwiftLocks
import XCTest

#if canImport(Dispatch)
import Dispatch
#endif

class LockableTestCaseBase: XCTestCase {

  final func runPerformanceTest(lock: Lockable) {
    var value = 0
    self.measure {
      runBlock(blockCount: 16, runsPerBlock: 100_000) {
        lock.lock()
        value = value + 2
        value = value - 1
        lock.unlock()
      }
    }
  }

  final func runBasicLockTest(lock: Lockable) {
    var value = 0

    runBlock(blockCount: 32, runsPerBlock: 1000) {
      lock.lock()
      value = value + 2
      value = value - 1
      lock.unlock()
    }

    XCTAssertEqual(value, 32_000)
  }

  // MARK: XCTestCase

  override class var defaultTestSuite: XCTestSuite {
    guard self != LockableTestCaseBase.self else {
      return XCTestSuite(name: "LockableTestCaseBase")
    }

    return super.defaultTestSuite
  }

}

// MARK: - Utilities

extension LockableTestCaseBase {

  final func runBlock(
    blockCount: Int,
    runsPerBlock: Int,
    handler: @escaping () -> Void
  ) {
    #if canImport(Dispatch)
    runBlock_Dispatch(blockCount: blockCount, runsPerBlock: runsPerBlock, handler: handler)
    #else
    XCTFail("Not implemented")
    #endif
  }

}

// MARK: - Dispatch Implementation

#if canImport(Dispatch)

extension LockableTestCaseBase {

  /// - SeeAlso: https://gist.github.com/RomanTruba/65e403377a9b8a39f0b1727c9c8299a9
  /// - SeeAlso: https://gist.github.com/steipete/36350a8a60693d440954b95ea6cbbafc
  private final func runBlock_Dispatch(
    blockCount: Int,
    runsPerBlock: Int,
    handler: @escaping () -> Void,
    timeout: DispatchTime = .distantFuture
  ) {
    let queues = [
      DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive),
      DispatchQueue.global(qos: DispatchQoS.QoSClass.default),
      DispatchQueue.global(qos: DispatchQoS.QoSClass.utility),
    ]

    let group = DispatchGroup.init()
    for block in 0..<blockCount {
      group.enter()
      let queue = queues[block % queues.count]
      queue.async(execute: {
        for _ in 0..<runsPerBlock {
          handler()
        }
        group.leave()
      })
    }

    let result = group.wait(timeout: timeout)
    XCTAssertEqual(result, .success, "Timed out waiting for threads to finish")
  }

}

#endif  // canImport(Dispatch)
