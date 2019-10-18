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

#if canImport(Foundation)

import CoreSwiftLocks
import XCTest

final class NSLockTests: LockableTestCase {

  override func makeLock() -> Lockable {
    return NSLock()
  }

}

#endif  // canImport(Foundation)
