//
//  UpdateResult.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

/// Result of an update on a story or chapter.
///
/// The `.failure` case has an associated `String` that is intended to be the error message.
public enum UpdateResult: Equatable {
  case unchanged
  case success
  case failure(String)
}

extension UpdateResult {
  /// `true` is `self` is `.failure`, else `false`
  public var isFailure: Bool {
    switch self {
    case .failure(_): return true
    default:          return false
    }
  }
}
