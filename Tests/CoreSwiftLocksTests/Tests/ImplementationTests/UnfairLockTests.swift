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

@available(OSX 10.12, iOS 10, tvOS 10, *)
class UnfairLockTests: XCTestCase {

  final func testBasicLocking() throws {
    #if canImport(Darwin)
    let lock = UnfairLock()
    runBasicLockTest(lock: lock)
    #endif  // canImport(Darwin)
  }

  final func testTryLock() throws {
    #if canImport(Darwin)
    let lock = UnfairLock()
    runTryLockTest(lock: lock)
    #endif  // canImport(Darwin)
  }

  final func testPerformance() {
    #if canImport(Darwin)
    let lock = UnfairLock()
    runPerformanceTest(lock: lock)
    #endif  // canImport(Darwin)
  }

}
