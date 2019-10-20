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

import Darwin.os

/// Implementation of `Lockable` which uses an `os_unfair_lock`.
@available(OSX 10.12, iOS 10, tvOS 10, *)
public class UnfairLock: Lockable {

  /// The `os_unfair_lock` underlying this class.
  private var mutex = os_unfair_lock()

  /// Creates a new `UnfairLock`.
  public init() {}

  //  MARK: Lockable

  public func lock() {
    os_unfair_lock_lock(&mutex)
  }

  public func unlock() {
    os_unfair_lock_unlock(&mutex)
  }

  public func tryLock() -> Bool {
    return os_unfair_lock_trylock(&mutex)
  }

}

#endif  // canImport(Darwin)
