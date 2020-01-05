//
//  UniverseTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-01.
//  See LICENSE at the root of the project.
//
// This file only tests the default implementations.

import XCTest
@testable import ffn_dl

final class UniverseTests: XCTestCase {
  // MARK: - Conformances tests

  let singleChapterURL = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

  let expectedURL = URL(string: "https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/")!
  let expectedName = "Harry Potter + Marvel Crossover"
  let expectedIsCrossover = Bool.random()

  // MARK: Equatable tests

  func testEqualityOnSameUniverseReturnsTrue() {
    let uni = Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover)
    let uni2 = Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover)

    XCTAssertEqual(uni, uni2)
  }

  func testEqualityOnUniversesWithDifferentNamesReturnsTrue() {
    let uni = Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover)
    let uni2 = Universe(url: singleChapterURL, name: "\(expectedName)AddOn", isCrossover: expectedIsCrossover)

    XCTAssertEqual(uni, uni2)
  }

  func testEqualityOnUniverseWithDifferentCrossoverReturnsTrue() {
    let uni = Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover)
    let uni2 = Universe(url: singleChapterURL, name: expectedName, isCrossover: !expectedIsCrossover)

    XCTAssertEqual(uni, uni2)
  }


  func testEqualityOnUniversesWithDifferentURLsReturnsFalse() {
    let uni = Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover)
    let uni2 = Universe(url: expectedURL, name: expectedName, isCrossover: expectedIsCrossover)

    XCTAssertNotEqual(uni, uni2)
  }

  func testEqualityOnUniversesWithDifferentURLsAndNamesReturnsFalse() {
    let uni = Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover)
    let uni2 = Universe(url: expectedURL, name: "\(expectedName)AddOn", isCrossover: expectedIsCrossover)

    XCTAssertNotEqual(uni, uni2)
  }

  func testEqualityOnUniversesWithDifferentURLsAndNamesAndCrossoverReturnsFalse() {
    let uni = Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover)
    let uni2 = Universe(url: expectedURL, name: "\(expectedName)AddOn", isCrossover: !expectedIsCrossover)

    XCTAssertNotEqual(uni, uni2)
  }

  // MARK: Hashable tests

  func testHashabilityOnSameUniverseReturnsTrue() {
    var h = Hasher()
    Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover).hash(into: &h)
    let uni_h = h.finalize()
    var h2 = Hasher()
    Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover).hash(into: &h2)
    let uni2_h = h2.finalize()

    XCTAssertEqual(uni_h, uni2_h)
  }

  func testHashabilityOnUniversesWithDifferentNamesReturnsTrue() {
    var h = Hasher()
    Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover).hash(into: &h)
    let uni_h = h.finalize()
    var h2 = Hasher()
    Universe(url: singleChapterURL, name: "\(expectedName)AddOn", isCrossover: expectedIsCrossover).hash(into: &h2)
    let uni2_h = h2.finalize()

    XCTAssertEqual(uni_h, uni2_h)
  }

  func testHashabilityOnUniversesWithDifferentCrossoverReturnsTrue() {
    var h = Hasher()
    Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover).hash(into: &h)
    let uni_h = h.finalize()
    var h2 = Hasher()
    Universe(url: singleChapterURL, name: "\(expectedName)AddOn", isCrossover: !expectedIsCrossover).hash(into: &h2)
    let uni2_h = h2.finalize()

    XCTAssertEqual(uni_h, uni2_h)
  }

  func testHashabilityOnUniversesWithDifferentURLsReturnsFalse() {
    var h = Hasher()
    Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover).hash(into: &h)
    let uni_h = h.finalize()
    var h2 = Hasher()
    Universe(url: expectedURL, name: expectedName, isCrossover: expectedIsCrossover).hash(into: &h2)
    let uni2_h = h2.finalize()

    XCTAssertNotEqual(uni_h, uni2_h)
  }

  func testHashabilityOnUniversesWithDifferentURLsAndNameReturnsFalse() {
    var h = Hasher()
    Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover).hash(into: &h)
    let uni_h = h.finalize()
    var h2 = Hasher()
    Universe(url: expectedURL, name: "\(expectedName)AddOn", isCrossover: expectedIsCrossover).hash(into: &h2)
    let uni2_h = h2.finalize()

    XCTAssertNotEqual(uni_h, uni2_h)
  }

  func testHashabilityOnUniversesWithDifferentURLsAndNamesAndCrossoverReturnsFalse() {
    var h = Hasher()
    Universe(url: singleChapterURL, name: expectedName, isCrossover: expectedIsCrossover).hash(into: &h)
    let uni_h = h.finalize()
    var h2 = Hasher()
    Universe(url: expectedURL, name: "\(expectedName)AddOn", isCrossover: !expectedIsCrossover).hash(into: &h2)
    let uni2_h = h2.finalize()

    XCTAssertNotEqual(uni_h, uni2_h)
  }
}

final class NonCrossoverUniverseTests: XCTestCase {
  // MARK: - Non-Crossover Expected Values

  /// This fic **is** a crossover with the url:
  /// - https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/
  /// - Harry Potter + Marvel Crossover
  let multiChapterURL = URL(fileURLWithPath: "\(pathToTestDir)/multiChapterFic.html")

  let expectedURL = URL(string: "https://www.fanfiction.net/book/Harry-Potter/")!
  let expectedName = "Harry Potter"
  let expectedIsCrossover = false

  // MARK: Finders

  lazy var successfulFinder = Universe.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in self.expectedName },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  lazy var nilURLFinder = Universe.Finder(
    findURL: { _ in nil },
    findName: { _ in self.expectedName },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  lazy var nilNameFinder = Universe.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in nil },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  // MARK: Non-crossover success case tests

  func testSuccessfulInitFromURL() {
    let res = Universe(from: multiChapterURL, withFinder: successfulFinder)!

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.name, expectedName)
    XCTAssertFalse(res.isCrossover)
  }

  func testSuccessfulInitFromDocument() {
    let doc = multiChapterURL.getDocument()!

    let res = Universe(from: doc, withFinder: successfulFinder)!

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.name, expectedName)
    XCTAssertFalse(res.isCrossover)
  }

  func testSuccessfulUniverseDescription() {
    let res = Universe(from: multiChapterURL, withFinder: successfulFinder)!

    let desc = "Harry Potter - https://www.fanfiction.net/book/Harry-Potter/"
    XCTAssertEqual("\(res)", desc)
  }

  // MARK: Found nil url tests

  func testInitFromURLWhenFoundURLIsNilReturnsNil() {
    let res = Universe(from: multiChapterURL, withFinder: nilURLFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenFoundURLIsNilReturnsNil() {
    let doc = multiChapterURL.getDocument()!

    let res = Universe(from: doc, withFinder: nilURLFinder)

    XCTAssertNil(res)
  }

  // MARK: Found nil name tests

  func testInitFromURLWhenNameIsNilReturnsNil() {
    let res = Universe(from: multiChapterURL, withFinder: nilNameFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenNameIsNilReturnsNil() {
    let doc = multiChapterURL.getDocument()!

    let res = Universe(from: doc, withFinder: nilNameFinder)

    XCTAssertNil(res)
  }

  // MARK: Invalid URL

  func testInitFromInvalidURLReturnsNils() {
    let invalidURL = URL(fileURLWithPath: "/")
    let res = Universe(from: invalidURL, withFinder: successfulFinder)

    XCTAssertNil(res)
  }
}

final class CrossoverUniverseTests: XCTestCase {
  // MARK: - Crossover Expected Values

  /// This fic is **not** a crossover with the url:
  /// - https://www.fanfiction.net/book/Harry-Potter/
  /// - Harry Potter
  let singleChapterURL = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

  let expectedURL = URL(string: "https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/")!
  let expectedName = "Harry Potter + Marvel Crossover"
  let expectedIsCrossover = true

  // MARK: Finders

  lazy var successfulFinder = Universe.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in self.expectedName },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  lazy var nilURLFinder = Universe.Finder(
    findURL: { _ in nil },
    findName: { _ in self.expectedName },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  lazy var nilNameFinder = Universe.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in nil },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  // MARK: Crossover success case tests

  func testSuccessfulInitFromURL() {
    let res = Universe(from: singleChapterURL, withFinder: successfulFinder)!

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.name, expectedName)
    XCTAssertTrue(res.isCrossover)
  }

  func testSuccessfulInitFromDocument() {
    let doc = singleChapterURL.getDocument()!

    let res = Universe(from: doc, withFinder: successfulFinder)!

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.name, expectedName)
    XCTAssertTrue(res.isCrossover)
  }

  func testSuccessfulUniverseDescription() {
    let res = Universe(from: singleChapterURL, withFinder: successfulFinder)!

    let desc = "Harry Potter + Marvel Crossover - https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/"
    XCTAssertEqual("\(res)", desc)
  }

  // MARK: Found nil url tests

  func testInitFromURLWhenFoundURLIsNilReturnsNil() {
    let res = Universe(from: singleChapterURL, withFinder: nilURLFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenFoundURLIsNilReturnsNil() {
    let doc = singleChapterURL.getDocument()!

    let res = Universe(from: doc, withFinder: nilURLFinder)

    XCTAssertNil(res)
  }

  // MARK: Found nil name tests

  func testInitFromURLWhenNameIsNilReturnsNil() {
    let res = Universe(from: singleChapterURL, withFinder: nilNameFinder)

    XCTAssertNil(res)
  }

  func testInitFromDocumentWhenNameIsNilReturnsNil() {
    let doc = singleChapterURL.getDocument()!

    let res = Universe(from: doc, withFinder: nilNameFinder)

    XCTAssertNil(res)
  }

  // MARK: Invalid URL

  func testInitFromInvalidURLReturnsNils() {
    let invalidURL = URL(fileURLWithPath: "/")
    let res = Universe(from: invalidURL, withFinder: successfulFinder)

    XCTAssertNil(res)
  }
}
