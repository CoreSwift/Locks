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

#include "cxx_lock.h"

#include <memory>
#include <mutex>

// MARK: - Abstract Base Class

struct _CoreSwiftCxxLock {
 public:
  virtual void lock() = 0;
  virtual void unlock() = 0;
  virtual bool try_lock() = 0;
  virtual ~_CoreSwiftCxxLock() {}
};

// MARK: - Implementation

template<class Mutex>
struct CoreSwiftCxxLock: public virtual _CoreSwiftCxxLock {
 public:
  CoreSwiftCxxLock(Mutex *m) : m(std::move(m)) {}
  ~CoreSwiftCxxLock() { delete m; }

  void lock() { m->lock(); }
  void unlock() { m->unlock(); }
  bool try_lock() { return m->try_lock(); }

  CoreSwiftCxxLock(const CoreSwiftCxxLock&) = delete;
  CoreSwiftCxxLock& operator=(const CoreSwiftCxxLock&) = delete;
 private:
  Mutex *m;
};

// MARK: - C API

CoreSwiftCxxLockRef CoreSwiftCxxLockCreate() {
  return new CoreSwiftCxxLock<std::mutex>(new std::mutex());
}

CoreSwiftCxxLockRef CoreSwiftCxxLockCreateRecursive() {
  return new CoreSwiftCxxLock<std::recursive_mutex>(new std::recursive_mutex());
}

void CoreSwiftCxxLockDestroy(CoreSwiftCxxLockRef opaque) {
  delete opaque;
}

void CoreSwiftCxxLockLock(CoreSwiftCxxLockRef opaque) {
  opaque->lock();
}

void CoreSwiftCxxLockUnlock(CoreSwiftCxxLockRef opaque) {
  opaque->unlock();
}

bool CoreSwiftCxxLockTry(CoreSwiftCxxLockRef opaque) {
  return opaque->try_lock();
}
