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
      runBlock(concurrency: 16, repetitions: 100_000) {
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

  func runTryLockTest(lock: Lockable) {
    #if canImport(Dispatch)
    runTryLockTest_Dispatch(lock: lock)
    #else
    XCTFail("Not implemented")
    #endif
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

      // Because it's a recursive lock and we are already holding the lock, this `tryLock` should
      // always succeed.
      XCTAssertTrue(lock.tryLock())
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
      let queue = queues[queueIdx % queues.count]
      queue.async(group: group) {
        for _ in 0..<repetitions {
          block()
        }
      }
    }

    let result = group.wait(timeout: timeout)
    XCTAssertEqual(result, .success, "Timed out waiting for threads to finish")
  }

  private final func runTryLockTest_Dispatch(lock: Lockable) {
    let outerQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.userInteractive)
    let innerQueue = DispatchQueue.global(qos: DispatchQoS.QoSClass.utility)
    let outerGroup = DispatchGroup()

    outerQueue.async(group: outerGroup) {
      // First try should always succeed.
      XCTAssertTrue(lock.tryLock())

      let innerGroup = DispatchGroup()
      innerQueue.async(group: innerGroup) {
        // Outer queue still holding the lock, this `tryLock` should always fail.
        XCTAssertFalse(lock.tryLock())
      }

      let result = innerGroup.wait(timeout: .now() + 20)
      XCTAssertEqual(result, .success, "Timed out waiting for inner queue to finish")

      lock.unlock()
    }

    let result = outerGroup.wait(timeout: .now() + 60)
    XCTAssertEqual(result, .success, "Timed out waiting for outer queue to finish")
  }
}

#endif  // canImport(Dispatch)
