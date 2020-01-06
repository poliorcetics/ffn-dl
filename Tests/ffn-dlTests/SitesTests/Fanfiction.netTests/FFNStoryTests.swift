//
//  FFNStoryTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-03.
//  See LICENSE at the root of the project.
//

import XCTest
@testable import ffn_dl

final class FFNStoryTests: XCTestCase {
  static let localURL = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")
  static let doc = localURL.getDocument()!

  static let trueURL = URL(string: "https://www.fanfiction.net/s/4951074/1")!
  static let title = "Harry's Little Army of Psychos"
  static let summary = "Oneshot from Ron’s POV. Ron tries to explain to the twins just how Harry made the Ministry of Magic make a new classification for magical creatures, and why the puffskeins were now considered the scariest magical creature of all time. No pairings."
  static let chapter = Chapter(from: doc, withFinder: FFNStory.chapterFinder)!
  static let author = Author(from: doc, withFinder: FFNStory.authorFinder)!
  static let universe = Universe(from: doc, withFinder: FFNStory.universeFinder)!
  static let tokens = "Rated: Fiction T - English - Humor/Adventure - Ron W., Harry P. - Words: 4,308 - Reviews: 805 - Favs: 6,784 - Follows: 1,409 - Published: 3/27/2009 - Status: Complete - id: 4951074"
  static let shortTokens = "T - English - Humor/Adventure - Ron W., Harry P."

  static let wordCount = 4308
  static let htmlFilename = "harry-s-little-army-of-psychos_infos.html"

  func testMemberWiseInitIsCorrect() {
    let story = FFNStory(url: Self.trueURL,
                        title: Self.title,
                         summary: Self.summary,
                         chapters: [Self.chapter],
                         author: Self.author,
                         universe: Self.universe,
                         tokens: Self.tokens)

    testLocalSingleChapterStory(story)
  }

  func testValidLocalURLForSingleChapteredFicSingleUniverse() {
    let story = FFNStory(from: Self.localURL)!

    testLocalSingleChapterStory(story,
                                testingChapters: false,
                                testingUpdates: false)
  }

  func testValidLocalDocForSingleChapteredFicSingleUniverse() {
    let story = FFNStory(from: Self.doc)!

    testLocalSingleChapterStory(story,
                                testingChapters: false,
                                testingUpdates: false)
  }

  func testUpdateWithEmptyChaptersListFails() {
    var story = FFNStory(from: Self.doc)!

    let oldStory = story
    let res = story.update(chapters: [])

    XCTAssertEqual(res.state, UpdateResult.failure("No chapters to update"))
    XCTAssertEqual(res.updatedChapters, [])
    XCTAssertEqual(oldStory, story)
  }

  func testUpdateWithNegativeChapterInListFails() {
    var story = FFNStory(from: Self.doc)!

    let oldStory = story
    let res = story.update(chapters: [3, 4, -1, 2])

    XCTAssertEqual(res.state, UpdateResult.failure("-1 is not a valid chapter"))
    XCTAssertEqual(res.updatedChapters, [])
    XCTAssertEqual(oldStory, story)
  }

  func testUpdateWithZeroChapterInListFails() {
    var story = FFNStory(from: Self.doc)!

    let oldStory = story
    let res = story.update(chapters: [3, 0, 4, 2])

    XCTAssertEqual(res.state, UpdateResult.failure("0 is not a valid chapter"))
    XCTAssertEqual(res.updatedChapters, [])
    XCTAssertEqual(oldStory, story)
  }

  /// Helper to test stories
  func testLocalSingleChapterStory(
    _ story: FFNStory, testingChapters: Bool = true, testingUpdates: Bool = true, line: UInt = #line
  ) {
    // Given values
    XCTAssertEqual(story.url, Self.trueURL, "URL Verif failed", line: line)
    XCTAssertEqual(story.title, Self.title, "Title Verif failed", line: line)
    XCTAssertEqual(story.summary, Self.summary, "Summary Verif failed", line: line)

    if testingChapters {
      XCTAssertEqual(story.chapters, [Self.chapter], "Chapters Verif failed", line: line)
    }

    XCTAssertEqual(story.author, Self.author, "Author Verif failed", line: line)
    XCTAssertEqual(story.universe, Self.universe, "Universe Verif failed", line: line)
    XCTAssertEqual(story.tokens, Self.tokens, "Tokens Verif failed", line: line)
    XCTAssertEqual(story.shortTokens, Self.shortTokens, "Short Tokens Verif failed", line: line)

    // Computed values
    XCTAssertEqual(story.chapterCount, 1, "Chapter count Verif failed", line: line)
    XCTAssertEqual(story.wordCount, Self.wordCount, "Word count Verif failed", line: line)
    XCTAssertEqual(story.language, "English", "Language Verif failed", line: line)
    XCTAssertEqual(story.status, Status.complete, "Status Verif failed", line: line)
    XCTAssertTrue(story.isComplete, "isComplete Verif failed", line: line)
    XCTAssertFalse(story.isCrossover, "isCrossover Verif failed", line: line)

    if testingUpdates {
      XCTAssertEqual(story.oldestChapterUpdate, Self.chapter.lastUpdate, "Oldest update Verif failed", line: line)
      XCTAssertEqual(story.newestChapterUpdate, Self.chapter.lastUpdate, "Newest update Verif failed", line: line)
    }

    XCTAssertEqual(story.HTMLInformationsFilename, Self.htmlFilename, "HTML infos filename Verif failed", line: line)
  }
}
