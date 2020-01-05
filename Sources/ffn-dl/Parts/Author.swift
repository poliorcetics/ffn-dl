//
//  Author.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2020-01-01.
//  See LICENSE at the root of the project.
//

import Foundation

/// An author of fanfictions.
///
/// Conformances to `Equatable` and `Hashable` only consider `url`.
public struct Author {
  /// URL to the author's page.
  public let url: URL

  /// Name of the author.
  public let name: String

  internal init(url: URL, name: String) {
    self.url = url
    self.name = name
  }
}

public extension Author {
  // MARK: - Author.Finder

  /// A `Author.Finder` gathers the necessary method to find all relevant informations about the author inside a document.
  ///
  /// The given `Document` can be anything the user whish it to be as long as it allows
  /// getting the author from it.
  struct Finder {
    /// Used to find the URL in a given document.
    ///
    /// Returns `nil` on failure.
    public let findURL: (Document) -> URL?

    /// Used to find the name in a given document.
    ///
    /// Returns `nil` on failure.
    public let findName: (Document) -> String?

    public init(findURL: @escaping (Document) -> URL?,
                findName: @escaping (Document) -> String?) {
      self.findURL = findURL
      self.findName = findName
    }
  }
}

public extension Author {
  // MARK: - Init

  init?(from url: URL, withFinder finder: Author.Finder) {
    guard let doc = url.getDocument() else {
      return nil
    }
    self.init(from: doc, withFinder: finder)
  }

  init?(from doc: Document, withFinder finder: Author.Finder) {
    guard let url = finder.findURL(doc),
      let name = finder.findName(doc)
      else {
        return nil
    }
    self.init(url: url, name: name)
  }
}

extension Author: Equatable {
  // MARK: - Equatable

  /// Only considers `url`.
  public static func ==(lhs: Self, rhs: Self) -> Bool {
    lhs.url == rhs.url
  }
}

extension Author: Hashable {
  // MARK: - Hashable

  /// Only considers `url`.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(url)
  }
}

extension Author: CustomStringConvertible {
  // MARK: - CustomStringConvertible

  public var description: String {
    "\(name) - \(url.absoluteString)"
  }
}
