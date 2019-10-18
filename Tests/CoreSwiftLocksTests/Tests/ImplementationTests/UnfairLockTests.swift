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

#if canImport(Darwin)

import CoreSwiftLocks
import XCTest

@available(OSX 10.12, iOS 10, tvOS 10, *)
final class UnfairLockTests: LockableTestCase {

  override func makeLock() -> Lockable {
    return UnfairLock()
  }

}

#endif  // canImport(Darwin)
