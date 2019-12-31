//
//  Status.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

enum Status: String, CaseIterable, Equatable {
  case complete = "Complete"
  case inProgress = "In Progress"
  case abandonned = "Abandonned"
}

extension Status: CustomStringConvertible {
  var description: String {
    rawValue
  }
}
