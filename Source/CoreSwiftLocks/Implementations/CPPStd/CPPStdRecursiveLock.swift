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

import CoreSwiftCxxLock

/// Implementation of `RecursiveLockable` which uses a `std::recursive_mutex`.
public class RecursiveCPPStdLock: RecursiveLockable {
  /// The c++ mutex to use.
  private var mutex: CoreSwiftCxxLockRef

  public init() {
    self.mutex = CoreSwiftCxxLockCreateRecursive()
  }

  deinit {
    CoreSwiftCxxLockDestroy(mutex)
  }

  public func lock() {
    CoreSwiftCxxLockLock(mutex)
  }

  public func unlock() {
    CoreSwiftCxxLockUnlock(mutex)
  }

  public func tryLock() -> Bool {
    return CoreSwiftCxxLockTry(mutex)
  }
}
