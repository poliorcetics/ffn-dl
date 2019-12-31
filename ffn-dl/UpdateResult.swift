//
//  UpdateResult.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

enum UpdateResult: Equatable {
  case unchanged
  case success
  case failure(String)
}

extension UpdateResult {
  var isFailure: Bool {
    switch self {
    case .failure(_): return true
    default:          return false
    }
  }
}