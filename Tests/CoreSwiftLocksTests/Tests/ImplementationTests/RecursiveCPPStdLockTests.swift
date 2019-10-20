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

class RecursiveCPPStdLockTests: XCTestCase {

  func testBasicLocking() {
    let lock = RecursiveCPPStdLock()
    runBasicLockTest(lock: lock)
  }

  func testRecursiveLocking() {
    let lock = RecursiveCPPStdLock()
    runRecursiveLockTest(lock: lock)
  }

  final func testTryLock() throws {
    let lock = RecursiveCPPStdLock()
    runTryLockTest(lock: lock)
  }

  func testPerformance() {
    let lock = RecursiveCPPStdLock()
    runPerformanceTest(lock: lock)
  }

}
