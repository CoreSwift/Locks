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

/// Implementation of `RecursiveLockable` which uses an pthreads.
public class RecursivePThreadLock: PThreadLock, RecursiveLockable {
  /// Creates a new `RecursivePThreadLock`.
  public init() {
    do {
      super.init(mutex: try PThreadMutex(semantics: .recursive))
    } catch let error {
      fatalError("Unable to create recursive pthread mutex lock: \(error)")
    }
  }
}

#endif  // canImport(Darwin) || canImport(Glibc)
