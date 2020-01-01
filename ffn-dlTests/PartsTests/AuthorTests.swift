//
//  AuthorTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-01.
//  Copyright © 2020 Alexis Bourget. All rights reserved.
//
// This file only tests the default implementations.

import XCTest
@testable import ffn_dl

final class AuthorTests: XCTestCase {
  // MARK: Expected values

  // This fic has an author with the url:
  // https://www.fanfiction.net/u/1122504/RuneWitchSakura
  // RuneWitchSakura
  let singleChapterURL = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

  let expectedURL = URL(string: "https://www.fanfiction.net/u/4785338/Vimesenthusiast")
  let expectedName = "Vimesenthusiast"

  // MARK: Finders

  lazy var successfulFinder = Author.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in self.expectedName }
  )

  lazy var nilURLFinder = Author.Finder(
    findURL: { _ in nil },
    findName: { _ in self.expectedName }
  )

  lazy var nilNameFinder = Author.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in nil }
  )

  // MARK: Success case tests

  func testSuccessfulInitFromURL() {
    let res = Author(from: singleChapterURL, withFinder: successfulFinder)!

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.name, expectedName)
  }

  func testSuccessfulInitFromDoc() {
    let doc = singleChapterURL.getDocument()!

    let res = Author(from: doc, withFinder: successfulFinder)!

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.name, expectedName)
  }

  func testSuccessfulAuthorDescription() {
    let url = URL(fileURLWithPath: "\(pathToTestDir)/multiChapterFic.html")

    let author = Author(from: url, withFinder: successfulFinder)!

    let desc = "Vimesenthusiast - https://www.fanfiction.net/u/4785338/Vimesenthusiast"
    XCTAssertEqual("\(author)", desc)
  }

  // MARK: Found nil url tests

  func testInitFromURLWhenFoundURLIsNilReturnsNil() {
    let res = Author(from: singleChapterURL, withFinder: nilURLFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenFoundURLIsNilReturnsNil() {
    let doc = singleChapterURL.getDocument()!

    let res = Author(from: doc, withFinder: nilURLFinder)

    XCTAssertNil(res)
  }

  // MARK: Found nil name tests

  func testInitFromURLWhenNameIsNilReturnsNil() {
    let res = Author(from: singleChapterURL, withFinder: nilNameFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenNameIsNilReturnsNil() {
    let doc = singleChapterURL.getDocument()!

    let res = Author(from: doc, withFinder: nilNameFinder)

    XCTAssertNil(res)
  }

  // MARK: Invalid URL

  func testInitFromInvalidURLReturnsNils() {
    let url = URL(fileURLWithPath: "/")
    let res = Author(from: url, withFinder: successfulFinder)

    XCTAssertNil(res)
  }
}
