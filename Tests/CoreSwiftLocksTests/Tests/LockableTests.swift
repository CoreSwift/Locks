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

class LockableTests: XCTestCase {
  /// Test that ensures the `locked` method actually uses the given lock.
  func testLocked_UsesLock() {
    let lock = FakeLock()

    XCTAssertEqual(lock.count, 0)
    lock.locked {
      XCTAssertEqual(lock.count, 1)
    }
    XCTAssertEqual(lock.count, 0)
  }

  /// Test that the `locked` method returns the proper result.
  func testLocked_ReturnValue() {
    class Box<T> {
      let value: T
      init(_ value: T) { self.value = value }
    }

    let lock = FakeLock()

    let valueResult = lock.locked {
      return 42
    }

    XCTAssertEqual(valueResult, 42)

    let reference = Box("foo")
    let objectResult = lock.locked {
      return reference
    }

    XCTAssertEqual(objectResult.value, reference.value)
    XCTAssertTrue(objectResult === reference)
  }

  /// Test that the `locked` method uses the same mutex when called recursively.
  func testLocked_Recursive() {
    let lock = FakeLock()

    XCTAssertEqual(lock.count, 0)
    lock.locked {
      XCTAssertEqual(lock.count, 1)

      lock.locked {
        XCTAssertEqual(lock.count, 2)
      }

      XCTAssertEqual(lock.count, 1)
    }
    XCTAssertEqual(lock.count, 0)
  }

  /// Test that the `locked` method uses different mutexes, even when called recursively.
  func testLocked_MultipleLocks() {
    let outer = FakeLock()
    let inner = FakeLock()

    XCTAssertEqual(outer.count, 0)
    XCTAssertEqual(inner.count, 0)

    outer.locked {
      XCTAssertEqual(outer.count, 1)
      XCTAssertEqual(inner.count, 0)

      inner.locked {
        XCTAssertEqual(outer.count, 1)
        XCTAssertEqual(inner.count, 1)
      }

      XCTAssertEqual(outer.count, 1)
      XCTAssertEqual(inner.count, 0)
    }

    XCTAssertEqual(outer.count, 0)
    XCTAssertEqual(inner.count, 0)
  }
}
