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

import Foundation

#if canImport(Darwin)
import Darwin.C
#elseif canImport(Glibc)
import Glibc
#endif

/// Private wrapper class around a pthread mutex.
///
/// - Remark: The throwable nature of this class makes it unsuitable for direct use as a `Lockable`,
///   hence it being a private implementation.
class PThreadMutex {

  /// The type of pthread lock to create.
  enum Semantics {
    /// The lock should be normal (i.e. not recursive).
    case normal
    /// The lock should support recursive usage.
    case recursive

    /// Returns a pthread-friendly mutex type for the given lock type.
    var mutexType: Int32 {
      switch self {
      case .normal: return Int32(PTHREAD_MUTEX_NORMAL)
      case .recursive: return Int32(PTHREAD_MUTEX_RECURSIVE)
      }
    }
  }

  /// The pthread mutex backing this class.
  private var mutex = pthread_mutex_t()

  /// Creates a new `Mutex` with the given locking semantics.
  init(semantics: Semantics = .normal) throws {
    var attributes = pthread_mutexattr_t()
    pthread_mutexattr_init(&attributes)
    pthread_mutexattr_settype(&attributes, semantics.mutexType)
    defer {
      pthread_mutexattr_destroy(&attributes)
    }

    let code = pthread_mutex_init(&mutex, &attributes)
    guard code == 0 else {
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(code))
    }
  }

  deinit {
    pthread_mutex_destroy(&mutex)
  }

  /// Locks the mutex.
  func lock() throws {
    let code = pthread_mutex_lock(&self.mutex)
    guard code == 0 else {
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(code))
    }
  }

  /// Unlocks the mutex.
  func unlock() throws {
    let code = pthread_mutex_unlock(&self.mutex)
    guard code == 0 else {
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(code))
    }
  }

  /// Tries to lock the mutex, returning true if the operation succeeded.
  func tryLock() throws -> Bool {
    let code = pthread_mutex_trylock(&self.mutex)
    switch code {
    case 0:
      return true
    case EBUSY:
      return false
    default:
      throw NSError(domain: NSPOSIXErrorDomain, code: Int(code))
    }
  }

}

#endif  // canImport(Darwin) || canImport(Glibc)
