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

class RecursivePTthreadLockTests: XCTestCase {

  func testBasicLocking() {
    #if canImport(Darwin) || canImport(Glibc)
    let lock = RecursivePThreadLock()
    runBasicLockTest(lock: lock)
    #endif  // canImport(Darwin) || canImport(Glibc)
  }

  func testRecursiveLocking() {
    #if canImport(Darwin) || canImport(Glibc)
    let lock = RecursivePThreadLock()
    runRecursiveLockTest(lock: lock)
    #endif  // canImport(Darwin) || canImport(Glibc)
  }

  func testPerformance() {
    #if canImport(Darwin) || canImport(Glibc)
    let lock = RecursivePThreadLock()
    runPerformanceTest(lock: lock)
    #endif  // canImport(Darwin) || canImport(Glibc)
  }

}
