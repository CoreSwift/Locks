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

import Locks
import XCTest

class CPPStdLockTests: XCTestCase {

  final func testBasicLocking() throws {
    let lock = CPPStdLock()
    runBasicLockTest(lock: lock)
  }

  final func testTryLock() throws {
    let lock = CPPStdLock()
    runTryLockTest(lock: lock)
  }

  final func testPerformance() {
    let lock = CPPStdLock()
    runPerformanceTest(lock: lock)
  }

}
