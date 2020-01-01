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

  internal init(url: URL, name: String, isCrossover: Bool) {
    self.url = url
    self.name = name
    self.isCrossover = isCrossover
  }
}

public extension Universe {
  // MARK: - Universe.Finder

  /// A `Universe.Finder` gathers the necessary method to find all relevant informations about the universe inside a document.
  ///
  /// The given `Document` can be anything the user whish it to be as long as it allows
  /// getting the universe from it.
  struct Finder {
    /// Used to find the URL in a given document.
    ///
    /// Returns `nil` on failure.
    public let findURL: (Document) -> URL?

    /// Used to find the name in a given document.
    ///
    /// Returns `nil` on failure.
    public let findName: (Document) -> String?

    /// Used to find the whether the given universe is a crossover in a given document.
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

public extension Universe {
  // MARK: - Init

  init?(from url: URL, withFinder finder: Universe.Finder) {
    guard let doc = url.getDocument() else {
      return nil
    }
    self.init(from: doc, withFinder: finder)
  }

  init?(from doc: Document, withFinder finder: Universe.Finder) {
    guard let url = finder.findURL(doc),
          let name = finder.findName(doc)
    else {
      return nil
    }
    let isCrossover = finder.findCrossover(doc)
    self.init(url: url, name: name, isCrossover: isCrossover)
  }
}

extension Universe: CustomStringConvertible {
  // MARK: - CustomStringConvertible

  public var description: String {
    "\(name) - \(url.absoluteString)"
  }
}
