//
//  Universe.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2020-01-01.
//  Copyright © 2020 Alexis Bourget. All rights reserved.
//

import Foundation

/// A Universe for fanfictions.
///
/// Examples: *Harry Potter*, *Star Wars*, *Star Wars + Harry Potter*.
public struct Universe {
  /// URL to the universe page.
  public let url: URL

  /// Name of the universe.
  public let name: String

  /// Whether the universe is a crossover or not.
  ///
  /// A crossover is a gathering of several (at least two) universes.
  /// It brings together lore and characters.
  ///
  /// **Examples**:
  ///
  /// - *Star Wars + Harry Potter* is a crossover.
  /// - *Star Wars* is **not** a crossover.
  public let isCrossover: Bool
}

public extension Universe {
  struct Finder {
    /// Returns `nil` on failure.
    public let findURL: (Document) -> URL?
    /// Returns `nil` on failure.
    public let findName: (Document) -> String?

    public let findCrossover: (Document) -> Bool

    public init(findURL: @escaping (Document) -> URL?,
                findName: @escaping (Document) -> String?,
                findCrossover: @escaping (Document) -> Bool) {
      self.findURL = findURL
      self.findName = findName
      self.findCrossover = findCrossover
    }
  }
}
