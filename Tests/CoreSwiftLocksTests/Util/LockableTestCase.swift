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

class LockableTestCase: LockableTestCaseBase {

  func makeLock() -> Lockable {
    XCTFail("Must be overridden by subclasses")
    fatalError("Must be overridden by subclasses")
  }

  // MARK: Tests

  final func testBasicLocking() throws {
    let lock = makeLock()

    runBasicLockTest(lock: lock)
  }

  final func testPerformance() {
    let lock = makeLock()

    runPerformanceTest(lock: lock)
  }

  // MARK: XCTestCase

  override class var defaultTestSuite: XCTestSuite {
    guard self != LockableTestCase.self else {
      return XCTestSuite(name: "LockableTestCase")
    }

    return super.defaultTestSuite
  }

}
