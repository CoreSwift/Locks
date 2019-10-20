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

import Foundation

extension NSRecursiveLock: RecursiveLockable {

  public func tryLock() -> Bool {
    return self.try()
  }

}
