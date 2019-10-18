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

#if canImport(Foundation)
import Foundation
#elseif canImport(Darwin)
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
      case .normal: return PTHREAD_MUTEX_NORMAL
      case .recursive: return PTHREAD_MUTEX_RECURSIVE
      }
    }
  }

  /// Errors which can be thrown by the mutex.
  enum Errors: Error {
    /// A well-defined POSIX error occurred.
    case posixError(code: Int32)

    /// Makes an appropriate POSIX error based on the current platform.
    static func makePOSIXError(code: Int32) -> Error {
      #if canImport(Foundation)
      return NSError(domain: NSPOSIXErrorDomain, code: Int(code))
      #else
      return Errors.posixError(code: code)
      #endif
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
      throw Errors.makePOSIXError(code: code)
    }
  }

  deinit {
    pthread_mutex_destroy(&mutex)
  }

  /// Locks the mutex.
  func lock() throws {
    let code = pthread_mutex_lock(&self.mutex)
    guard code == 0 else {
      throw Errors.makePOSIXError(code: code)
    }
  }

  /// Unlocks the mutex.
  func unlock() throws {
    let code = pthread_mutex_unlock(&self.mutex)
    guard code == 0 else {
      throw Errors.makePOSIXError(code: code)
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
      throw Errors.makePOSIXError(code: code)
    }
  }

}

#endif  // canImport(Foundation) || canImport(Darwin) || canImport(Glibc)
