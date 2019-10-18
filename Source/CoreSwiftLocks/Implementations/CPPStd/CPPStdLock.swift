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

/// Implementation of `Lockable` which uses a `std::mutex`.
public class CPPStdLock: Lockable {
  /// The c++ mutex to use.
  private var mutex: CoreSwiftCxxLockRef

  public init() {
    self.mutex = CoreSwiftCxxLockCreate()
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
