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

/// An instance which can be used to synchronize access between threads.
public protocol Lockable {

  /// Obtains ownership of the lock. Will block the current thread until the lock is obtained.
  func lock()

  /// Releases ownership of the lock. Is a fatal error if the current thread isn't the locks owner.
  func unlock()

  /// Attempts to obtain the lock.
  ///
  /// - Returns: True if the lock was obtained, false otherwise.
  func tryLock() -> Bool

  /// Performs the given `work` while holding a lock on the receiver.
  func locked<T>(work: () throws -> T) rethrows -> T

}

/// An instance of `Lockable` which can be safely locked multiple times from the same thread.
public protocol RecursiveLockable: Lockable {
}
