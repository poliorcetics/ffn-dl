//
//  Story.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2020-01-01.
//  See LICENSE at the root of the project.
//

import Foundation

/// A protocol representing a story.
///
/// A correctly-built story will always have **at least one valid chapter**.
public protocol Story: CustomStringConvertible {
  /// Website associated with the story.
  static var site: Site.Type { get }

  /// URL to the first chapter and/or description of the story.
  var url: URL { get }

  /// Title of the story.
  ///
  /// Should not contains extraneous informations like the author or universe.
  var title: String { get }
  /// Summary of the story.
  var summary: String { get }
  /// The chapters that make up the story's content.
  ///
  /// **Every** story should have at least one chapter and it is an error to allow
  /// for an empty story to exist.
  var chapters: [Chapter] { get }

  /// Author of the story.
  var author: Author { get }
  /// Universe of the story.
  var universe: Universe { get }
  /// Status of the story.
  var status: Status { get }
  /// Language of the story.
  var language: String { get }

  /// Number of chapters in the story.
  ///
  /// Default implementation: number of chapters in `self.chapters`
  var chapterCount: Int { get }
  /// Number of words in the story.
  var wordCount: Int { get }

  /// All tokens for the story. Can contains informations like characters, type an so on.
  var tokens: String { get }
  /// A shortened version of the tokens, suitable for display in a limited space.
  ///
  /// Default implementation: equal to `self.token`.
  var shortTokens: String { get }

  /// Indicates whether the story was updated or not, and, if it was, exactly which chapters were.
  typealias UpdateResult = (state: ffn_dl.UpdateResult, updatedChapters: [Int])

  /// Updates the story, by updating the last known chapter and any new chapter.
  mutating func update() -> Story.UpdateResult

  /// Updates the given chapters as well as any new chapter.
  /// Chapters are indexed starting at one here.
  mutating func update(chapters: [Int]) -> Story.UpdateResult

  /// Attempts to initialize a full story fro a given `URL`.
  /// - Parameters:
  ///   - url: `URL` to use to get the chapter.
  init?(from url: URL)

  /// Attempts to initialize a full story fro a given `Document`.
  /// - Parameters:
  ///   - doc: `Document` to use to get the chapter.
  init?(from doc: Document)
}

public extension Story {
  // MARK: Non-overridable computed variables

  /// `true` if the story is complete.
  var isComplete: Bool {
    status == .complete
  }

  /// `true` if the story is a crossover.
  var isCrossover: Bool {
    universe.isCrossover
  }

  /// Oldest update amongst the story's chapters.
  ///
  /// The update date is taken from the `.lastUpdate` member of the chapters.
  var oldestChapterUpdate: Date {
    let oldestChapter = chapters.min { $0.lastUpdate < $1.lastUpdate }
    return oldestChapter!.lastUpdate
  }

  /// Most recent update amongst the story's chapters.
  ///
  /// The update date is taken from the `.lastUpdate` member of the chapters.
  var newestChapterUpdate: Date {
    let newestChapter = chapters.max { $0.lastUpdate < $1.lastUpdate }
    return newestChapter!.lastUpdate
  }
}

// MARK: - Default implementations

public extension Story {
  // MARK: Computed variables

  var chapterCount: Int {
    chapters.count
  }

  var shortTokens: String {
    tokens
  }
}

public extension Story {
  // MARK: Update

  mutating func update() -> Story.UpdateResult {
    update(chapters: [chapterCount - 1])
  }
}

public extension Story {
  // MARK: Init

  init?(from url: URL) {
    guard let doc = url.getDocument() else {
      return nil
    }
    self.init(from: doc)
  }
}

extension Story {
  // MARK: CustomStringConvertible

  public var description: String {
    let chaptersDesc = chapters
      .map { "\($0)" }
      .joined(separator: "\n")
    return """
    \(title)
    URL: \(url.absoluteString)
    ===============
    Author: \(author)

    Universe: \(universe)

    Summary: \(summary)

    Language: \(language)
    Status: \(status)

    Updates:
    Oldest: \(oldestChapterUpdate.description)
    Newest: \(newestChapterUpdate.description)

    \(tokens)
    ---------------
    \(chaptersDesc)
    """
  }
}
