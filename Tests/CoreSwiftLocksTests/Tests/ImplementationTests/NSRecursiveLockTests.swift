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

class NSRecursiveLockTests: XCTestCase {

  func testBasicLocking() {
    #if canImport(Foundation)
    let lock = NSRecursiveLock()
    runBasicLockTest(lock: lock)
    #endif  // canImport(Foundation)
  }

  func testRecursiveLocking() {
    #if canImport(Foundation)
    let lock = NSRecursiveLock()
    runRecursiveLockTest(lock: lock)
    #endif  // canImport(Foundation)
  }

  func testPerformance() {
    #if canImport(Foundation)
    let lock = NSRecursiveLock()
    runPerformanceTest(lock: lock)
    #endif  // canImport(Foundation)
  }

}
