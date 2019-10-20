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

class PThreadLockTests: XCTestCase {

  final func testBasicLocking() throws {
    #if canImport(Darwin) || canImport(Glibc)
    let lock = PThreadLock()
    runBasicLockTest(lock: lock)
    #endif  // canImport(Darwin) || canImport(Glibc)
  }

  final func testTryLock() throws {
    #if canImport(Darwin) || canImport(Glibc)
    let lock = PThreadLock()
    runTryLockTest(lock: lock)
    #endif  // canImport(Darwin) || canImport(Glibc)
  }

  final func testPerformance() {
    #if canImport(Darwin) || canImport(Glibc)
    let lock = PThreadLock()
    runPerformanceTest(lock: lock)
    #endif  // canImport(Darwin) || canImport(Glibc)
  }

}
