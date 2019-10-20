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
//
// C shims around `std::mutex` and `std::recursive_mutex` in order to use
// them from Swift.
//
// -------------------------------------------------------------------------- //

#ifndef cxx_lock_h
#define cxx_lock_h

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct _CoreSwiftCxxLock *CoreSwiftCxxLockRef;

/** Creates an opaque reference to a `std::mutex` suitable for use in Swift. */
CoreSwiftCxxLockRef _Nonnull CoreSwiftCxxLockCreate();

/** Creates an opaque reference to a `std::recursive_mutex` suitable for use in Swift. */
CoreSwiftCxxLockRef _Nonnull CoreSwiftCxxLockCreateRecursive();

/** Destroys the given lock. */
void CoreSwiftCxxLockDestroy(CoreSwiftCxxLockRef _Nonnull lock);

/** Locks the given lock. */
void CoreSwiftCxxLockLock(CoreSwiftCxxLockRef _Nonnull lock);

/** Unlocks the given lock. */
void CoreSwiftCxxLockUnlock(CoreSwiftCxxLockRef _Nonnull lock);

/** Tries to lock the given lock. */
bool CoreSwiftCxxLockTry(CoreSwiftCxxLockRef _Nonnull lock);

#ifdef __cplusplus
}
#endif

#endif /* cxx_lock_h */
