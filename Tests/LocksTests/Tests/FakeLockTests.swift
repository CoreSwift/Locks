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

/// Tests for the fake implementation of `Lockable`.
class FakeLockTests: XCTestCase {
  /// Test that ensures the `lock()` method increments the counter and `unlock()` decrements it.
  func testLock() {
    let lock = FakeLock()

    XCTAssertEqual(lock.count, 0)
    lock.lock()
    XCTAssertEqual(lock.count, 1)
    lock.lock()
    XCTAssertEqual(lock.count, 2)
    lock.unlock()
    XCTAssertEqual(lock.count, 1)
    lock.unlock()
    XCTAssertEqual(lock.count, 0)
  }

  func testTryLock() {
    let lock = FakeLock()

    XCTAssertEqual(lock.count, 0)
    XCTAssertTrue(lock.tryLock())
    XCTAssertEqual(lock.count, 1)
    XCTAssertFalse(lock.tryLock())
    XCTAssertEqual(lock.count, 1)
    lock.unlock()
    XCTAssertEqual(lock.count, 0)
  }
}
