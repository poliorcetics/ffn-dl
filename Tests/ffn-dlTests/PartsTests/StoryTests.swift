//
//  StoryTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-02.
//  See LICENSE at the root of the project.
//

import XCTest
@testable import ffn_dl

// This file only tests the default implementations

// MARK: - Mock Implementations

fileprivate enum MockSite: Site {
  static let name = "Ultimate HP FFN"
  static let mainURL = URL(string: "https://ultimatehpfanfiction.com")!
  static let regex = NSRegularExpression("https://(?:www.)?ultimatehpfanfiction.com/.+?")
}

fileprivate struct MockChapterBuilder {
  static let url = URL(string: "https://www.fanfiction.net/s/4951074/1/Harry-s-Little-Army-of-Psychos")!
  static let title = "Test Chapter Title"
  static let content = "Test chapter content"
  static let lastUpdate = Date()

  static let finder = Chapter.Finder(
    findURL: { _ in url },
    findTitle: { _ in title },
    findContent: { _ in content }
  )

  static func build() -> Chapter {
    Chapter(from: url, withFinder: finder)!
  }
}

fileprivate struct MockAuthorBuilder {
  static let url = URL(string: "https://www.fanfiction.net/u/1122504/RuneWitchSakura")!
  static let name = "RuneWitchSakura"

  static let finder = Author.Finder(
    findURL: { _ in url },
    findName: { _ in name }
  )

  static func build() -> Author {
    Author(from: url, withFinder: finder)!
  }
}

fileprivate struct MockUniverseBuilder {
  static let url = URL(string: "https://www.fanfiction.net/book/Harry-Potter/")!
  static let name = "Harry Potter"
  static let isCrossover = false

  static let finder = Universe.Finder(
    findURL: { _ in url },
    findName: { _ in name },
    findCrossover: { _ in isCrossover }
  )

  static func build() -> Universe {
    Universe(from: url, withFinder: finder)!
  }
}

fileprivate struct MockStory: Story {
  typealias Site = MockSite

  let url = URL(string: "https://www.fanfiction.net/s/4951074/1/Harry-s-Little-Army-of-Psychos")!

  let title = "Test Title"
  let summary = "Test summary"
  let chapters = [
    MockChapterBuilder.build(),
    MockChapterBuilder.build(),
    MockChapterBuilder.build()
  ]

  let author = MockAuthorBuilder.build()
  let universe = MockUniverseBuilder.build()
  let status = Status.complete
  let language = "English"

  let wordCount = 1000
  let tokens = "Test tokens"

  // Always failing, the parsing of a Document is not the point here
  init?(from doc: Document) {
    nil
  }

  // For successful init
  init() {}

  func update(chapters: [Int]) -> Story.UpdateResult {
    (.failure(""), [])
  }
}

// MARK: Test class

final class StoryTests: XCTestCase {
  private let story = MockStory()

  func testChapterCount() {
    XCTAssertEqual(story.chapterCount, story.chapters.count)
  }

  func testShortTokens() {
    XCTAssertEqual(story.shortTokens, story.tokens)
  }

  func testIsComplete() {
    XCTAssertTrue(story.isComplete)
  }

  func testIsCrossover() {
    XCTAssertEqual(story.isCrossover, story.universe.isCrossover)
  }

  func testOldestChapterUpdate() {
    XCTAssertEqual(story.oldestChapterUpdate, story.chapters[0].lastUpdate)
  }

  func testNewestChapterUpdate() {
    XCTAssertEqual(story.newestChapterUpdate, story.chapters[2].lastUpdate)
  }

  func testHTMLInformationsFilename() {
    XCTAssertEqual(story.HTMLInformationsFilename, "test-title_infos.html")
  }

  func testDescription() {
    let desc = """
    \(story.title)
    URL: \(story.url.absoluteString)
    ===============
    Author: \(story.author)

    Universe: \(story.universe)

    Summary: \(story.summary)

    Language: \(story.language)
    Status: \(story.status)

    Updates:
    Oldest: \(story.oldestChapterUpdate.description)
    Newest: \(story.newestChapterUpdate.description)

    \(story.tokens)
    ---------------
    \(story.chapters[0])
    \(story.chapters[1])
    \(story.chapters[2])
    """

    XCTAssertEqual(story.description, desc)
  }

  func testUpdate() {
    var story = MockStory()
    let res = story.update()

    XCTAssertEqual(res.state, UpdateResult.failure(""))
    XCTAssertEqual(res.updatedChapters, [])
  }

  func testInitByURLFails() {
    let url = URL(string: "\(pathToTestDir)/singleChapterFic.html")!

    let story = MockStory(from: url)

    XCTAssertNil(story)
  }

  func testInitByDocumentFails() {
    let doc = Document.parse(html: "")!

    let story = MockStory(from: doc)

    XCTAssertNil(story)
  }
}

