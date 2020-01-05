//
//  Status.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

/// Status of a fanfiction, indicating whether it is complete, in progress or abandonned.
public enum Status: String, CaseIterable, Equatable {
  case complete = "Complete"
  case inProgress = "In Progress"
  case abandonned = "Abandonned"
}

extension Status: CustomStringConvertible {
  public var description: String {
    rawValue
  }
}
