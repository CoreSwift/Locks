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
import XCTest
import CoreSwiftLocks

class RecursiveLockableTestCase: LockableTestCaseBase {

  func makeLock() -> RecursiveLockable {
    XCTFail("Must be overridden by subclasses")
    fatalError("Must be overridden by subclasses")
  }

  // MARK: Tests

  final func testBasicLocking() throws {
    let lock = makeLock()

    runBasicLockTest(lock: lock)
  }

  final func testRecursiveLocking() {
    let lock = makeLock()

    var value = 0

    runBlock(blockCount: 32, runsPerBlock: 1000) {
      lock.lock()

      value = value + 2
      value = value - 1

      lock.lock()
      value = value + 2
      value = value - 1
      lock.unlock()

      value = value + 2
      value = value - 1

      lock.unlock()
    }

    XCTAssertEqual(value, 96_000)
  }

  final func testPerformance() {
    let lock = makeLock()

    runPerformanceTest(lock: lock)
  }

  // MARK: XCTestCase

  override class var defaultTestSuite: XCTestSuite {
    guard self != RecursiveLockableTestCase.self else {
      return XCTestSuite(name: "RecursiveLockableTestCase")
    }

    return super.defaultTestSuite
  }

}
