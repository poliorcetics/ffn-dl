//
//  UniverseTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-01.
//  Copyright © 2020 Alexis Bourget. All rights reserved.
//

import XCTest
@testable import ffn_dl

// This file only tests the default implementations

// MARK: - SuccessfulUniNonCrossoverTests

final class SuccessfulUniNonCrossoverTests: XCTestCase {
  // This fic is a crossover with the url:
  // https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/
  // Harry Potter + Marvel Crossover
  let url = URL(fileURLWithPath: "\(pathToTestDir)/multiChapterFic.html")

  let expectedURL = URL(string: "https://www.fanfiction.net/book/Harry-Potter/")!
  let expectedUniName = "Harry Potter"
  let expectedIsCrossover = false

  lazy var finder = Universe.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in self.expectedUniName },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  func testSuccessfulUniverseNonCrossoverFromURL() {
    let uni = Universe(from: url, withFinder: finder)!

    XCTAssertEqual(uni.url, expectedURL)
    XCTAssertEqual(uni.name, expectedUniName)
    XCTAssertFalse(uni.isCrossover)
  }

  func testSuccessfulUniverseNonCrossoverFromDoc() {
    let doc = url.getDocument()!

    let uni = Universe(from: doc, withFinder: finder)!

    XCTAssertEqual(uni.url, expectedURL)
    XCTAssertEqual(uni.name, expectedUniName)
    XCTAssertFalse(uni.isCrossover)
  }

  func testSuccessfulUniverseDescription() {
    let url = URL(fileURLWithPath: "\(pathToTestDir)/multiChapterFic.html")

    let universe = Universe(from: url, withFinder: finder)!

    let desc = "Harry Potter - https://www.fanfiction.net/book/Harry-Potter/"
    XCTAssertEqual("\(universe)", desc)
  }
}

// MARK: - SuccessfulUniCrossoverTests

final class SuccessfulUniCrossoverTests: XCTestCase {
  // This fic is not a crossover with the url:
  // https://www.fanfiction.net/book/Harry-Potter/
  // Harry Potter
  let url = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

  let expectedURL = URL(string: "https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/")!
  let expectedUniName = "Harry Potter + Marvel Crossover"
  let expectedIsCrossover = true

  lazy var finder = Universe.Finder(
    findURL: { _ in self.expectedURL },
    findName: { _ in self.expectedUniName },
    findCrossover: { _ in self.expectedIsCrossover }
  )

  func testSuccessfulUniverseNonCrossoverFromURL() {
    let uni = Universe(from: url, withFinder: finder)!

    XCTAssertEqual(uni.url, expectedURL)
    XCTAssertEqual(uni.name, expectedUniName)
    XCTAssertTrue(uni.isCrossover)
  }

  func testSuccessfulUniverseNonCrossoverFromDoc() {
    let doc = url.getDocument()!

    let uni = Universe(from: doc, withFinder: finder)!

    XCTAssertEqual(uni.url, expectedURL)
    XCTAssertEqual(uni.name, expectedUniName)
    XCTAssertTrue(uni.isCrossover)
  }

  func testSuccessfulUniverseDescription() {
    let url = URL(fileURLWithPath: "\(pathToTestDir)/singleChapterFic.html")

    let universe = Universe(from: url, withFinder: finder)!

    let desc = "Harry Potter + Marvel Crossover - https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/"
    XCTAssertEqual("\(universe)", desc)
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
    let uni = Universe(from: url, withFinder: finder)

    XCTAssertNil(uni)
  }

  func testSuccessfulUniverseNonCrossoverFromDoc() {
    let doc = url.getDocument()!

    let uni = Universe(from: doc, withFinder: finder)

    XCTAssertNil(uni)
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
    let uni = Universe(from: url, withFinder: finder)

    XCTAssertNil(uni)
  }

  func testSuccessfulUniverseNonCrossoverFromDoc() {
    let doc = url.getDocument()!

    let uni = Universe(from: doc, withFinder: finder)

    XCTAssertNil(uni)
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
    let uni = Universe(from: url, withFinder: finder)

    XCTAssertNil(uni)
  }
}
