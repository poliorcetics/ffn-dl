//
//  UniverseTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-01.
//  Copyright © 2020 Alexis Bourget. All rights reserved.
//
// This file only tests the default implementations.

import XCTest
@testable import ffn_dl

final class UniverseTests: XCTestCase {

  // This fic is a crossover with the url:
  // https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/
  // Harry Potter + Marvel Crossover
  let multiChapterURL = URL(fileURLWithPath: "\(pathToTestDir)/multiChapterFic.html")

  let nonCrossoverURL = URL(string: "https://www.fanfiction.net/book/Harry-Potter/")!
  let nonCrossoverName = "Harry Potter"
  let nonCrossoverIsCrossover = false

  lazy var nonCrossoverFinder = Universe.Finder(
    findURL: { _ in self.nonCrossoverURL },
    findName: { _ in self.nonCrossoverName },
    findCrossover: { _ in self.nonCrossoverIsCrossover }
  )

  func testSuccessfulUniverseNonCrossoverFromURL() {
    let res = Universe(from: multiChapterURL, withFinder: nonCrossoverFinder)!

    XCTAssertEqual(res.url, nonCrossoverURL)
    XCTAssertEqual(res.name, nonCrossoverName)
    XCTAssertFalse(res.isCrossover)
  }

  func testSuccessfulUniverseNonCrossoverFromDoc() {
    let doc = multiChapterURL.getDocument()!

    let res = Universe(from: doc, withFinder: nonCrossoverFinder)!

    XCTAssertEqual(res.url, nonCrossoverURL)
    XCTAssertEqual(res.name, nonCrossoverName)
    XCTAssertFalse(res.isCrossover)
  }

  func testSuccessfulUniverseDescription() {
    let url = URL(fileURLWithPath: "\(pathToTestDir)/multiChapterFic.html")

    let res = Universe(from: url, withFinder: nonCrossoverFinder)!

    let desc = "Harry Potter - https://www.fanfiction.net/book/Harry-Potter/"
    XCTAssertEqual("\(res)", desc)
  }
}

// MARK: - SuccessfulUniCrossoverTests

final class SuccessfulUniCrossoverTests: XCTestCase {
  // This fic is not a crossover with the url:
  // https://www.fanfiction.net/book/Harry-Potter/
  // Harry Potter
  let url = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

  let expectedURL = URL(string: "https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/")!
  let expectedName = "Harry Potter + Marvel Crossover"
  let expectedIsCrossover = true

  lazy var finder = Universe.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in self.expectedName },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  func testSuccessfulUniverseNonCrossoverFromURL() {
    let res = Universe(from: url, withFinder: finder)!

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.name, expectedName)
    XCTAssertTrue(res.isCrossover)
  }

  func testSuccessfulUniverseNonCrossoverFromDoc() {
    let doc = url.getDocument()!

    let res = Universe(from: doc, withFinder: finder)!

    XCTAssertEqual(res.url, expectedURL)
    XCTAssertEqual(res.name, expectedName)
    XCTAssertTrue(res.isCrossover)
  }

  func testSuccessfulUniverseDescription() {
    let url = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

    let res = Universe(from: url, withFinder: finder)!

    let desc = "Harry Potter + Marvel Crossover - https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/"
    XCTAssertEqual("\(res)", desc)
  }
}

// MARK: - SuccessfulUniCrossoverTests

final class FailingOnURLUniTests: XCTestCase {
  let url = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

  let finder = Universe.Finder(
    findURL: { _ in nil },
    findName: { _ in "Harry Potter + Marvel Crossover" },
    findCrossover: { _ in true }
  )

  func testSuccessfulUniverseNonCrossoverFromURL() {
    let res = Universe(from: url, withFinder: finder)

    XCTAssertNil(res)
  }

  func testSuccessfulUniverseNonCrossoverFromDoc() {
    let doc = url.getDocument()!

    let res = Universe(from: doc, withFinder: finder)

    XCTAssertNil(res)
  }
}

// MARK: - SuccessfulUniCrossoverTests

final class FailingOnNameUniTests: XCTestCase {
  let url = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

  let finder = Universe.Finder(
    findURL: { _ in URL(string: "https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/") },
    findName: { _ in nil },
    findCrossover: { _ in true }
  )

  func testSuccessfulUniverseNonCrossoverFromURL() {
    let res = Universe(from: url, withFinder: finder)

    XCTAssertNil(res)
  }

  func testSuccessfulUniverseNonCrossoverFromDoc() {
    let doc = url.getDocument()!

    let res = Universe(from: doc, withFinder: finder)

    XCTAssertNil(res)
  }
}

// MARK: - InvalidUrlUniverseTests

final class InvalidUrlUniverseTests: XCTestCase {
  let url = URL(fileURLWithPath: "/")

  let finder = Universe.Finder(
    findURL: { _ in URL(string: "https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/") },
    findName: { _ in nil },
    findCrossover: { _ in true }
  )

  func testFailingInitFromURL() {
    let res = Universe(from: url, withFinder: finder)

    XCTAssertNil(res)
  }
}
