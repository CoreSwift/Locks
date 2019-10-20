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

#if canImport(Darwin) || canImport(Glibc)

#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#endif

/// Implementation of `Lockable` which uses an pthreads.
public class PThreadLock: Lockable {
  /// The mutex backing this lock.
  private let mutex: PThreadMutex

  internal init(mutex: PThreadMutex) {
    self.mutex = mutex
  }

  // MARK: Lockable

  /// Creates a new `PThreadLock` with the given locking semantics.
  public convenience init() {
    do {
      self.init(mutex: try PThreadMutex(semantics: .normal))
    } catch let error {
      fatalError("Unable to create pthread mutex lock: \(error)")
    }
  }

  public func lock() {
    do {
      try mutex.lock()
    } catch let error {
      fatalError("Unable to lock pthread mutex lock: \(error)")
    }
  }

  public func unlock() {
    do {
      try mutex.unlock()
    } catch let error {
      fatalError("Unable to unlock pthread mutex lock: \(error)")
    }
  }

  public func tryLock() -> Bool {
    do {
      return try mutex.tryLock()
    } catch let error {
      fatalError("Unable to tryLock pthread mutex lock: \(error)")
    }
  }
}

#endif  // canImport(Darwin) || canImport(Glibc)
