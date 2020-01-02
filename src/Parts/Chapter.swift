//
//  Chapter.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import Foundation

/// A chapter inside a story.
public struct Chapter {
  /// URL of the chapter, should be as precise as possible.
  public let url: URL

  /// Title of the chapter.
  public let title: String

  /// Content of the chapter: the main text.
  public let content: String

  /// When the chapter was last updated **by the program** (not on the website).
  public let lastUpdate: Date

  private let finder: Chapter.Finder

  /// Initialize a chapter with all it's components known.
  /// - Parameters:
  ///   - url: URL of the chapter.
  ///   - title: Title of the chapter.
  ///   - content: Content of the chapter.
  ///   - lastUpdate: When the chapter was last updated **by the programm**.
  ///   - finder: The `Chapter.Finder` to use when updating this chapter.
  internal init(url: URL, title: String, content: String, lastUpdate: Date, finder: Chapter.Finder) {
    self.url = url
    self.title = title
    self.content = content
    self.lastUpdate = lastUpdate
    self.finder = finder
  }
}

public extension Chapter {
  // MARK: - Chapter.Finder

  /// A `Chapter.Finder` gathers the necessary method to find all relevant informations about chapter inside a document.
  ///
  /// The given `Document` can be anything the user whish it to be as long as it allows
  /// getting the chapter from it.
  struct Finder {
    /// Used to find the URL in a given document.
    ///
    /// Returns `nil` on failure.
    public let findURL: (Document) -> URL?

    /// Used to find the title in a given document.
    ///
    /// Returns `nil` on failure.
    public let findTitle: (Document) -> String?

    /// Used to find the content in a given document.
    ///
    /// Returns `nil` on failure.
    public let findContent: (Document) -> String?

    public init(findURL: @escaping (Document) -> URL?,
                findTitle: @escaping (Document) -> String?,
                findContent: @escaping (Document) -> String?) {
      self.findURL = findURL
      self.findTitle = findTitle
      self.findContent = findContent
    }
  }
}

public extension Chapter {
  // MARK: - Convenience init

  /// Attempts to initialize a chapter from a given `URL`, using the provided `Chapter.Finder`.
  /// - Parameters:
  ///   - url: `URL` to use to get the chapter.
  ///   - finder: `Chapter.Finder` to use to obtain the chapter's data.
  init?(from url: URL, withFinder finder: Chapter.Finder) {
    guard let doc = url.getDocument() else {
      return nil
    }
    self.init(from: doc, withFinder: finder)
  }

  /// Attempts to initialize a chapter from a given `Document`, using the provided `Chapter.Finder`.
  /// - Parameters:
  ///   - doc: `Document` in which to find the chapter.
  ///   - finder: `Chapter.Finder` to use to obtain the chapter's data.
  init?(from doc: Document, withFinder finder: Chapter.Finder) {
    guard let canonicalURL = finder.findURL(doc),
          let title = finder.findTitle(doc),
          let content = finder.findContent(doc)
    else {
      return nil
    }
    self.init(url: canonicalURL, title: title, content: content, lastUpdate: Date(), finder: finder)
  }
}

public extension Chapter {
  // MARK: - Updating

  /// Attempts to update `self`, returning an `UpdateResult` indicating how the operation
  /// went.
  ///
  /// - Note: In case of failure, the message is considered an implementation details.
  /// - Note: A chapter is considered to have changed if and only if it's **title** or **content** have changed. The update date and url are ignored for this.
  mutating func update() -> UpdateResult {
    guard let updatedChapter = Chapter(from: url, withFinder: finder) else {
      return .failure("Failed to update the chapter from '\(url.absoluteString)'")
    }

    // The URL should not have changed, and the update date should have changed
    let chapterChanged = title != updatedChapter.title || content != updatedChapter.content
    self = updatedChapter
    return chapterChanged ? .success : .unchanged
  }
}

extension Chapter: CustomStringConvertible {
  // MARK: - CustomStringConvertible

  public var description: String {
    "\(title) - \(lastUpdate) - \(url.absoluteString)"
  }
}
