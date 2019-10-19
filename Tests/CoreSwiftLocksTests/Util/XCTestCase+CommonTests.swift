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

extension XCTestCase {

  /// Runs a performance test on the given lock.
  ///
  /// - Parameter lock: The lock under test.
  func runPerformanceTest(lock: Lockable) {
    var value = 0
    self.measure {
      runBlock(concurrency: 16, repetitions: 1_000) {
        lock.lock()
        value = value + 2
        value = value - 1
        lock.unlock()
      }
    }
  }

  /// Runs a basic smoke test on the given lock.
  ///
  /// - Parameter lock: The lock under test.
  func runBasicLockTest(lock: Lockable) {
    var value = 0

    runBlock(concurrency: 32, repetitions: 1000) {
      lock.lock()
      value = value + 2
      value = value - 1
      lock.unlock()
    }

    XCTAssertEqual(value, 32_000)
  }

  /// Runs a basic smoke test on the given recursive lock.
  ///
  /// - Parameter lock: The lock under test.
  func runRecursiveLockTest(lock: RecursiveLockable) {
    var value = 0

    runBlock(concurrency: 32, repetitions: 1000) {
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

  /// Runs the given block a number of times across a number of different-priority threads.
  ///
  /// - Parameters:
  ///   - concurrency: The number of threads/queues/etc that should be simultaneously running the
  ///     giiven `block`.
  ///   - repetitions: The number of times that `block` should be run on each thread/queue/etc.
  ///   - block: The block that should be run concurrently.
  ///
  /// - Remark: The value provided in `concurrency` does not necessarily guarantee `N` unique
  ///   threads, as the system may or may not multiplex across a common thread pool.
  private func runBlock(
    concurrency: Int,
    repetitions: Int,
    block: @escaping () -> Void
  ) {
    #if canImport(Dispatch)
    runBlock_Dispatch(concurrency: concurrency, repetitions: repetitions, block: block)
    #else
    XCTFail("Not implemented")
    #endif
  }
}

// MARK: - Dispatch Implementation

#if canImport(Dispatch)

extension XCTestCase {

  /// Runs the given block a number of times across a number of different-priority queues.
  ///
  /// - Parameters:
  ///   - concurrency: The number of queues that should be simultaneously running `block`.
  ///   - repetitions: The number of times that `block` should be run on each queue.
  ///   - block: The block that should be run concurrently.
  ///
  /// - SeeAlso: https://gist.github.com/RomanTruba/65e403377a9b8a39f0b1727c9c8299a9
  /// - SeeAlso: https://gist.github.com/steipete/36350a8a60693d440954b95ea6cbbafc
  private final func runBlock_Dispatch(
    concurrency: Int,
    repetitions: Int,
    block: @escaping () -> Void,
    timeout: DispatchTime = .distantFuture
  ) {
    let queues = [
      DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive),
      DispatchQueue.global(qos: DispatchQoS.QoSClass.default),
      DispatchQueue.global(qos: DispatchQoS.QoSClass.utility),
    ]

    let group = DispatchGroup()

    for queueIdx in 0..<concurrency {
      group.enter()
      let queue = queues[queueIdx % queues.count]
      queue.async(execute: {
        for _ in 0..<repetitions {
          block()
        }
        group.leave()
      })
    }

    let result = group.wait(timeout: timeout)
    XCTAssertEqual(result, .success, "Timed out waiting for threads to finish")
  }

}

#endif  // canImport(Dispatch)
