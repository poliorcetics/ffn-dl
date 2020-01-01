//
//  Chapter.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import Foundation

/// A chapter inside a story.
public final class Chapter {
  /// URL of the chapter, should be as precise as possible.
  public private(set) var url: URL

  /// Title of the chapter.
  public private(set) var title: String

  /// Content of the chapter: the main text.
  public private(set) var content: String

  /// When the chapter was last updated **by the program** (not on the website).
  public private(set) var lastUpdate: Date

  private let finder: Chapter.Finder

  /// Initialize a chapter with all it's components known.
  /// - Parameters:
  ///   - url: URL of the chapter.
  ///   - title: Title of the chapter.
  ///   - content: Content of the chapter.
  ///   - lastUpdate: When the chapter was last updated **by the programm**.
  ///   - finder: The `Chapter.Finder` to use when updating this chapter.
  init(url: URL, title: String, content: String, lastUpdate: Date, finder: Chapter.Finder) {
    self.url = url
    self.title = title
    self.content = content
    self.lastUpdate = lastUpdate
    self.finder = finder
  }
}

extension Chapter {
  // MARK: - Chapter.Finder

  /// A `Chapter.Finder` gathers the necessary method to find all relevant informations about chapter inside a document.
  public struct Finder {
    /// Used to find the URL in a given document.
    public let findURL: (Document) -> URL?

    /// Used to find the title in a given document.
    public let findTitle: (Document) -> String?

    /// Used to find the content in a given document.
    public let findContent: (Body) -> String?

    public init(findURL: @escaping (Document) -> URL?,
                findTitle: @escaping (Document) -> String?,
                findContent: @escaping (Body) -> String?) {
      self.findURL = findURL
      self.findTitle = findTitle
      self.findContent = findContent
    }
  }
}

extension Chapter {
  // MARK: - Convenience init

  /// Attempts to initialize a chapter from a given `URL`, using the provided `Chapter.Finder`.
  /// - Parameters:
  ///   - url: `URL` to use to get the chapter.
  ///   - finder: `Chapter.Finder` to use to obtain the chapter's data.
  public convenience init?(from url: URL, withFinder finder: Chapter.Finder) {
    guard let doc = url.getDocument() else {
      return nil
    }
    self.init(from: doc, withFinder: finder)
  }

  /// Attempts to initialize a chapter from a given `Document`, using the provided `Chapter.Finder`.
  /// - Parameters:
  ///   - doc: `Document` in which to find the chapter.
  ///   - finder: `Chapter.Finder` to use to obtain the chapter's data.
  public convenience init?(from doc: Document, withFinder finder: Chapter.Finder) {
    guard let canonicalURL = finder.findURL(doc),
      let title = finder.findTitle(doc),
      let body = doc.body,
      let content = finder.findContent(body)
      else {
        return nil
    }
    self.init(url: canonicalURL, title: title, content: content, lastUpdate: Date(), finder: finder)
  }

  public func update() -> UpdateResult {
    guard let updatedChapter = Chapter(from: url, withFinder: finder) else {
      return .failure("Failed to update the chapter from '\(url.absoluteString)'")
    }

    // The URL should not have changed, and the update date should have changed
    let chapterChanged = title != updatedChapter.title || content != updatedChapter.content
    url = updatedChapter.url
    title = updatedChapter.title
    content = updatedChapter.content
    lastUpdate = updatedChapter.lastUpdate
    return chapterChanged ? .success : .unchanged
  }
}

extension Chapter: CustomStringConvertible {
  // MARK: - CustomStringConvertible

  public var description: String {
    "\(title) - \(lastUpdate) - \(url.absoluteString)"
  }
}