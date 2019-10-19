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

class NSLockTests: XCTestCase {

  final func testBasicLocking() throws {
    #if canImport(Foundation)
    let lock = NSLock()
    runBasicLockTest(lock: lock)
    #endif  // canImport(Foundation)
  }

  final func testPerformance() {
    #if canImport(Foundation)
    let lock = NSLock()
    runPerformanceTest(lock: lock)
    #endif  // canImport(Foundation)
  }

}

