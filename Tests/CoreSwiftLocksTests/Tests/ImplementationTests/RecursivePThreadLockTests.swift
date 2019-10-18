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

#if canImport(Foundation) || canImport(Darwin) || canImport(Glibc)

import CoreSwiftLocks
import XCTest

class RecursivePTthreadLockTests: RecursiveLockableTestCase {

  override func makeLock() -> RecursiveLockable {
    return RecursivePThreadLock()
  }

}

#endif  // canImport(Foundation) || canImport(Darwin) || canImport(Glibc)
