//
//  ChapterTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-01.
//  Copyright © 2020 Alexis Bourget. All rights reserved.
//
// This file only tests the default implementations.

import XCTest
@testable import ffn_dl

final class ChapterTests: XCTestCase {
  // MARK: Expected Values

  // This fic has a chapter with the url:
  // https://www.fanfiction.net/s/4951074/1/Harry-s-Little-Army-of-Psychos
  // Harry's Little Army of Psychos
  let singleChapterURL = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

  let expectedURL = URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future")!
  let expectedTitle = "1. A Stranger in an even Stranger Land"
  let expectedContent = "Chapter content"

  // MARK: Finders

  lazy var successfulFinder = Chapter.Finder(
    findURL: { _ in self.expectedURL },
    findTitle: { _ in self.expectedTitle },
    findContent: { _ in self.expectedContent }
  )

  lazy var nilURLFinder = Chapter.Finder(
    findURL: { _ in nil },
    findTitle: { _ in self.expectedTitle },
    findContent: { _ in self.expectedContent }
  )

  lazy var nilTitleFinder = Chapter.Finder(
    findURL: { _ in self.expectedURL },
    findTitle: { _ in nil },
    findContent: { _ in self.expectedContent }
  )

  lazy var nilContentFinder = Chapter.Finder(
    findURL: { _ in self.expectedURL },
    findTitle: { _ in self.expectedTitle },
    findContent: { _ in nil }
  )

  // MARK: Success case tests

  func testSuccessfulInitFromURL() {
    let res = Chapter(from: singleChapterURL, withFinder: successfulFinder)!

    let dateIsWithinRange = abs(Date().timeIntervalSince(res.lastUpdate)) < 5

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.title, expectedTitle)
    XCTAssertEqual(res.content, expectedContent)
    XCTAssertTrue(dateIsWithinRange)
  }

  func testSuccessfulInitFromDocument() {
    let doc = singleChapterURL.getDocument()!
    let res = Chapter(from: doc, withFinder: successfulFinder)!

    let dateIsWithinRange = abs(Date().timeIntervalSince(res.lastUpdate)) < 5

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.title, expectedTitle)
    XCTAssertEqual(res.content, expectedContent)
    XCTAssertTrue(dateIsWithinRange)
  }

  func testUpdateReturnsUnchangedWhenURLOrDateChanges() {
    let res = Chapter(
      url: singleChapterURL,
      title: expectedTitle,
      content: expectedContent,
      lastUpdate: Date(),
      finder: successfulFinder
    )

    let oldDate = res.lastUpdate

    // The url and date will have changed but are ignored
    XCTAssertEqual(res.update(), UpdateResult.unchanged)
    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.title, expectedTitle)
    XCTAssertEqual(res.content, expectedContent)
    XCTAssertGreaterThan(res.lastUpdate, oldDate)
  }

  func testUpdateReturnsSuccessWhenTitleChanges() {
    let res = Chapter(
      url: singleChapterURL,
      title: expectedTitle + "AddOn",
      content: expectedContent,
      lastUpdate: Date(),
      finder: successfulFinder
    )

    let oldDate = res.lastUpdate

    // The title will have changed
    XCTAssertEqual(res.update(), UpdateResult.success)
    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.title, expectedTitle)
    XCTAssertEqual(res.content, expectedContent)
    XCTAssertGreaterThan(res.lastUpdate, oldDate)
  }

  func testUpdateReturnsSuccessWhenContentChanges() {
    let res = Chapter(
      url: singleChapterURL,
      title: expectedTitle,
      content: expectedContent + "AddOn",
      lastUpdate: Date(),
      finder: successfulFinder
    )

    let oldDate = res.lastUpdate

    // The content will have changed
    XCTAssertEqual(res.update(), UpdateResult.success)
    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.title, expectedTitle)
    XCTAssertEqual(res.content, expectedContent)
    XCTAssertGreaterThan(res.lastUpdate, oldDate)
  }

  func testSuccessfulChapterDescription() {
    let res = Chapter(from: singleChapterURL, withFinder: successfulFinder)!

    let desc = "1. A Stranger in an even Stranger Land - \(res.lastUpdate) - https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future"
    XCTAssertEqual("\(res)", desc)
  }

  // MARK: Found nil url tests

  func testInitFromURLWhenFoundURLIsNilReturnsNil() {
    let res = Chapter(from: singleChapterURL, withFinder: nilURLFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenFoundURLIsNilReturnsNil() {
    let doc = singleChapterURL.getDocument()!

    let res = Chapter(from: doc, withFinder: nilURLFinder)

    XCTAssertNil(res)
  }

  func testUpdateReturnsFailureWithCorrectMessageWhenFoundURLIsNil() {
    let res = Chapter(
      url: expectedURL,
      title: expectedTitle,
      content: expectedContent,
      lastUpdate: Date(),
      finder: nilURLFinder
    )

    XCTAssertEqual(res.update(),
                   UpdateResult.failure("Failed to update the chapter from '\(res.url.absoluteString)'"))
  }

  // MARK: Found nil title tests

  func testInitFromURLWhenFoundTitleIsNilReturnsNil() {
    let res = Chapter(from: singleChapterURL, withFinder: nilTitleFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenFoundTitleIsNilReturnsNil() {
    let doc = singleChapterURL.getDocument()!

    let res = Chapter(from: doc, withFinder: nilTitleFinder)

    XCTAssertNil(res)
  }

  func testUpdateReturnsFailureWithCorrectMessageWhenFoundTitleIsNil() {
    let res = Chapter(
      url: expectedURL,
      title: expectedTitle,
      content: expectedContent,
      lastUpdate: Date(),
      finder: nilTitleFinder
    )

    XCTAssertEqual(res.update(),
                   UpdateResult.failure("Failed to update the chapter from '\(res.url.absoluteString)'"))
  }

  // MARK: Found nil content tests

  func testInitFromURLWhenFoundContentIsNilReturnsNil() {
    let res = Chapter(from: singleChapterURL, withFinder: nilContentFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenFoundContentIsNilReturnsNil() {
    let doc = singleChapterURL.getDocument()!

    let res = Chapter(from: doc, withFinder: nilContentFinder)

    XCTAssertNil(res)
  }

  func testUpdateReturnsFailureWithCorrectMessageWhenFoundContentIsNil() {
    let res = Chapter(
      url: expectedURL,
      title: expectedTitle,
      content: expectedContent,
      lastUpdate: Date(),
      finder: nilContentFinder
    )

    XCTAssertEqual(res.update(),
                   UpdateResult.failure("Failed to update the chapter from '\(res.url.absoluteString)'"))
  }

  // MARK: Invalid url tests

  func testInitFromInvalidURLReturnsNils() {
    let invalidURL = URL(fileURLWithPath: "/")
    let res = Chapter(from: invalidURL, withFinder: successfulFinder)

    XCTAssertNil(res)
  }
}
