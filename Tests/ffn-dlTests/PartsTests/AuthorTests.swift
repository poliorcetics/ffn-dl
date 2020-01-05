//
//  AuthorTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-01.
//  See LICENSE at the root of the project.
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

  let expectedURL = URL(string: "https://www.fanfiction.net/u/4785338/Vimesenthusiast")!
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
    let author = Author(from: singleChapterURL, withFinder: successfulFinder)!

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

  // MARK: Invalid URL test

  func testInitFromInvalidURLReturnsNils() {
    let invalidURL = URL(fileURLWithPath: "/")
    let res = Author(from: invalidURL, withFinder: successfulFinder)

    XCTAssertNil(res)
  }

  // MARK: Equatable tests

  func testEqualityOnSameAuthorReturnsTrue() {
    let author = Author(url: singleChapterURL, name: expectedName)
    let author2 = Author(url: singleChapterURL, name: expectedName)

    XCTAssertEqual(author, author2)
  }

  func testEqualityOnAuthorsWithDifferentNamesReturnsTrue() {
    let author = Author(url: singleChapterURL, name: expectedName)
    let author2 = Author(url: singleChapterURL, name: "\(expectedName)AddOn")

    XCTAssertEqual(author, author2)
  }

  func testEqualityOnAuthorsWithDifferentURLsReturnsFalse() {
    let author = Author(url: singleChapterURL, name: expectedName)
    let author2 = Author(url: expectedURL, name: expectedName)

    XCTAssertNotEqual(author, author2)
  }

  func testEqualityOnAuthorsWithDifferentURLsAndNameReturnsFalse() {
    let author = Author(url: singleChapterURL, name: expectedName)
    let author2 = Author(url: expectedURL, name: "\(expectedName)AddOn")

    XCTAssertNotEqual(author, author2)
  }

  // MARK: Hashable tests

  func testHashabilityOnSameAuthorReturnsTrue() {
    var h = Hasher()
    Author(url: singleChapterURL, name: expectedName).hash(into: &h)
    let author_h = h.finalize()
    var h2 = Hasher()
    Author(url: singleChapterURL, name: expectedName).hash(into: &h2)
    let author2_h = h2.finalize()

    XCTAssertEqual(author_h, author2_h)
  }

  func testHashabilityOnAuthorsWithDifferentNamesReturnsTrue() {
    var h = Hasher()
    Author(url: singleChapterURL, name: expectedName).hash(into: &h)
    let author_h = h.finalize()
    var h2 = Hasher()
    Author(url: singleChapterURL, name: "\(expectedName)AddOn").hash(into: &h2)
    let author2_h = h2.finalize()

    XCTAssertEqual(author_h, author2_h)
  }

  func testHashabilityOnAuthorsWithDifferentURLsReturnsFalse() {
    var h = Hasher()
    Author(url: singleChapterURL, name: expectedName).hash(into: &h)
    let author_h = h.finalize()
    var h2 = Hasher()
    Author(url: expectedURL, name: expectedName).hash(into: &h2)
    let author2_h = h2.finalize()

    XCTAssertNotEqual(author_h, author2_h)
  }

  func testHashabilityOnAuthorsWithDifferentURLsAndNameReturnsFalse() {
    var h = Hasher()
    Author(url: singleChapterURL, name: expectedName).hash(into: &h)
    let author_h = h.finalize()
    var h2 = Hasher()
    Author(url: expectedURL, name: "\(expectedName)AddOn").hash(into: &h2)
    let author2_h = h2.finalize()

    XCTAssertNotEqual(author_h, author2_h)
  }
}
