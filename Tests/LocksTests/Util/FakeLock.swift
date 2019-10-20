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

import Locks

/// A fake `Lockable` implementation which isn't suitable for real use.
class FakeLock: Lockable {

  /// The current count on this lock.
  private(set) var count: Int

  // MARK: Lockable

  /// Creates a new `FakeLock` with the given locking semantics.
  required init() {
    self.count = 0
  }

  func lock() {
    count += 1
  }

  func unlock() {
    count -= 1
  }

  func tryLock() -> Bool {
    if count == 0 {
      count += 1
      return true
    }

    return false
  }

}
