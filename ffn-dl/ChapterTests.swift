//
//  ChapterTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-01.
//  Copyright © 2020 Alexis Bourget. All rights reserved.
//

import XCTest
@testable import ffn_dl

// This file only tests the default implementations

// This fic has a chapter with the url:
// https://www.fanfiction.net/u/1122504/RuneWitchSakura
// Harry's Little Army of Psychos
fileprivate let singleChapterURL = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")
fileprivate let singleChapterDoc = singleChapterURL.getDocument()!

// MARK: - SuccessfulChapterTests

final class SuccessfulChapterTests: XCTestCase {
  let expectedURL = URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future")!
  let expectedTitle = "1. A Stranger in an even Stranger Land"
  let expectedContent = "Chapter content"

  lazy var finder = Chapter.Finder(findURL: { _ in self.expectedURL },
                                   findTitle: { _ in self.expectedTitle },
                                   findContent: { _ in self.expectedContent })

  func testSuccessfulInitFromURL() {
    let chapter = Chapter(from: singleChapterURL, withFinder: finder)!

    let dateIsWithinRange = abs(Date().timeIntervalSince(chapter.lastUpdate)) < 5

    XCTAssertEqual(chapter.url, expectedURL)
    XCTAssertEqual(chapter.title, expectedTitle)
    XCTAssertEqual(chapter.content, expectedContent)
    XCTAssertTrue(dateIsWithinRange)
  }

  func testSuccessfulInitFromDocument() {
    let chapter = Chapter(from: singleChapterDoc, withFinder: finder)!

    let dateIsWithinRange = abs(Date().timeIntervalSince(chapter.lastUpdate)) < 5

    XCTAssertEqual(chapter.url, expectedURL)
    XCTAssertEqual(chapter.title, expectedTitle)
    XCTAssertEqual(chapter.content, expectedContent)
    XCTAssertTrue(dateIsWithinRange)
  }

  func testUpdateReturnsUnchangedWhenURLOrDateChanges() {
    let chapter = Chapter(
      url: singleChapterURL,
      title: expectedTitle,
      content: expectedContent,
      lastUpdate: Date(),
      finder: finder)

    let oldDate = chapter.lastUpdate

    // The url and date will have changed but are ignored
    XCTAssertEqual(chapter.update(), UpdateResult.unchanged)
    XCTAssertEqual(chapter.url, expectedURL)
    XCTAssertEqual(chapter.title, expectedTitle)
    XCTAssertEqual(chapter.content, expectedContent)
    XCTAssertGreaterThan(chapter.lastUpdate, oldDate)
  }

  func testUpdateReturnsSuccessWhenTitleChanges() {
    let chapter = Chapter(
      url: singleChapterURL,
      title: expectedTitle + "AddOn",
      content: expectedContent,
      lastUpdate: Date(),
      finder: finder)

    let oldDate = chapter.lastUpdate

    // The title will have changed
    XCTAssertEqual(chapter.update(), UpdateResult.success)
    XCTAssertEqual(chapter.url, expectedURL)
    XCTAssertEqual(chapter.title, expectedTitle)
    XCTAssertEqual(chapter.content, expectedContent)
    XCTAssertGreaterThan(chapter.lastUpdate, oldDate)
  }

  func testUpdateReturnsSuccessWhenContentChanges() {
    let chapter = Chapter(
      url: singleChapterURL,
      title: expectedTitle,
      content: expectedContent + "AddOn",
      lastUpdate: Date(),
      finder: finder)

    let oldDate = chapter.lastUpdate

    // The content will have changed
    XCTAssertEqual(chapter.update(), UpdateResult.success)
    XCTAssertEqual(chapter.url, expectedURL)
    XCTAssertEqual(chapter.title, expectedTitle)
    XCTAssertEqual(chapter.content, expectedContent)
    XCTAssertGreaterThan(chapter.lastUpdate, oldDate)
  }

  func testSuccessfulChapterDescription() {
    let url = URL(fileURLWithPath: "\(pathToTestDir)/multiChapterFic.html")

    let chapter = Chapter(from: url, withFinder: finder)!

    let desc = "1. A Stranger in an even Stranger Land - \(chapter.lastUpdate) - https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future"
    XCTAssertEqual("\(chapter)", desc)
  }
}

// MARK: - FailingOnURLChapterTests

final class FailingOnURLChapterTests: XCTestCase {
  let finder = Chapter.Finder(findURL: { _ in nil },
                              findTitle: { _ in "1. A Stranger in an even Stranger Land" },
                              findContent: { _ in "Chapter content" })

  func testFailingInitFromURL() {
    let chapter = Chapter(from: singleChapterURL, withFinder: finder)

    XCTAssertNil(chapter)
  }

  func testFailingInitFromDocument() {
    let chapter = Chapter(from: singleChapterDoc, withFinder: finder)

    XCTAssertNil(chapter)
  }

  func testUpdateReturnsFailureWithCorrectMessage() {
    let chapter = Chapter(
      url: URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future")!,
      title: "1. A Stranger in an even Stranger Land",
      content: "Content text",
      lastUpdate: Date(),
      finder: finder)

    XCTAssertEqual(chapter.update(),
                   UpdateResult.failure("Failed to update the chapter from '\(chapter.url.absoluteString)'"))
  }
}

// MARK: - FailingOnTitleChapterTests

final class FailingOnTitleChapterTests: XCTestCase {
  let finder = Chapter.Finder(findURL: { _ in URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future") },
                              findTitle: { _ in nil },
                              findContent: { _ in "Chapter content" })

  func testFailingInitFromURL() {
    let chapter = Chapter(from: singleChapterURL, withFinder: finder)

    XCTAssertNil(chapter)
  }

  func testFailingInitFromDocument() {
    let chapter = Chapter(from: singleChapterDoc, withFinder: finder)

    XCTAssertNil(chapter)
  }

  func testUpdateReturnsFailureWithCorrectMessage() {
    let chapter = Chapter(
      url: URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future")!,
      title: "1. A Stranger in an even Stranger Land",
      content: "Content text",
      lastUpdate: Date(),
      finder: finder)

    XCTAssertEqual(chapter.update(),
                   UpdateResult.failure("Failed to update the chapter from '\(chapter.url.absoluteString)'"))
  }
}

// MARK: - FailingOnContentChapterTests

final class FailingOnContentChapterTests: XCTestCase {
  let finder = Chapter.Finder(findURL: { _ in URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future") },
                              findTitle: { _ in "1. A Stranger in an even Stranger Land" },
                              findContent: { _ in nil })

  func testFailingInitFromURL() {
    let chapter = Chapter(from: singleChapterURL, withFinder: finder)

    XCTAssertNil(chapter)
  }

  func testFailingInitFromDocument() {
    let chapter = Chapter(from: singleChapterDoc, withFinder: finder)

    XCTAssertNil(chapter)
  }

  func testUpdateReturnsFailureWithCorrectMessage() {
    let chapter = Chapter(
      url: URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future")!,
      title: "1. A Stranger in an even Stranger Land",
      content: "Content text",
      lastUpdate: Date(),
      finder: finder)

    XCTAssertEqual(chapter.update(),
                   UpdateResult.failure("Failed to update the chapter from '\(chapter.url.absoluteString)'"))
  }
}

// MARK:

final class InvalidUrlChapterTests: XCTestCase {
  let finder = Chapter.Finder(findURL: { _ in URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future") },
                              findTitle: { _ in "1. A Stranger in an even Stranger Land" },
                              findContent: { _ in "Chapter content" })

  let url = URL(fileURLWithPath: "/")

  func testFailingInitFromURL() {
    let chapter = Chapter(from: url, withFinder: finder)

    XCTAssertNil(chapter)
  }
}
