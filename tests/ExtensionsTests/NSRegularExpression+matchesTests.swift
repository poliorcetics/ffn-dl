//
//  NSRegularExpression+matchesTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-03.
//  Copyright © 2020 Alexis Bourget. All rights reserved.
//

import XCTest
@testable import ffn_dl

final class NSRegularExpressionTests: XCTestCase {
  // All tests will be done on those two regexes
  let oneOrMoreNumbersRegexString = #"^\d+$"#
  let basicHttpUrlRegexString = #"^(https?://)?(www\.)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(/.*)?$"#

  // Optionals are to ensure the instance of each regex are built before each test
  // and destroyed just after it, else XCode do not deallocate the memory during the tests
  var oneOrMoreNumbersRegex: NSRegularExpression!
  var basicHttpUrlRegex: NSRegularExpression!

  override func setUp() {
    oneOrMoreNumbersRegex = NSRegularExpression(oneOrMoreNumbersRegexString)
    basicHttpUrlRegex = NSRegularExpression(basicHttpUrlRegexString)
  }

  override func tearDown() {
    oneOrMoreNumbersRegex = nil
    basicHttpUrlRegex = nil
  }

  func testConvenienceInit() {
    let patternMessage = "The patterns should be equal"
    XCTAssertEqual(oneOrMoreNumbersRegexString, oneOrMoreNumbersRegex!.pattern, patternMessage)
    XCTAssertEqual(basicHttpUrlRegexString, basicHttpUrlRegex!.pattern, patternMessage)
  }

  func testMatchWithNoOptionsIsTrue() {
    let numberMessage = "Numbers should match"
    XCTAssertTrue(oneOrMoreNumbersRegex.matches("1"), numberMessage)
    XCTAssertTrue(oneOrMoreNumbersRegex.matches("12"), numberMessage)

    let urlMessage = "Valid URLs should match"
    XCTAssertTrue(basicHttpUrlRegex.matches("apple.com"), urlMessage)
    XCTAssertTrue(basicHttpUrlRegex.matches("www.apple.com"), urlMessage)

    XCTAssertTrue(basicHttpUrlRegex.matches("https://apple.com"), urlMessage)
    XCTAssertTrue(basicHttpUrlRegex.matches("https://apple.com/"), urlMessage)
    XCTAssertTrue(basicHttpUrlRegex.matches("https://apple.com/support"), urlMessage)
    XCTAssertTrue(basicHttpUrlRegex.matches("https://www.apple.com/support"), urlMessage)

    XCTAssertTrue(basicHttpUrlRegex.matches("http://apple.com"), urlMessage)
    XCTAssertTrue(basicHttpUrlRegex.matches("http://apple.com/"), urlMessage)
    XCTAssertTrue(basicHttpUrlRegex.matches("http://apple.com/support"), urlMessage)
    XCTAssertTrue(basicHttpUrlRegex.matches("http://www.apple.com/support"), urlMessage)
  }

  func testMatchWithNoOptionsIsFalse() {
    let numberMessage = "Non numbers-only should not match"
    XCTAssertFalse(oneOrMoreNumbersRegex.matches(""), numberMessage)
    XCTAssertFalse(oneOrMoreNumbersRegex.matches("a"), numberMessage)
    XCTAssertFalse(oneOrMoreNumbersRegex.matches("1a"), numberMessage)
    XCTAssertFalse(oneOrMoreNumbersRegex.matches("a1"), numberMessage)

    let urlMessage = "Invalid urls should not match"
    XCTAssertFalse(basicHttpUrlRegex.matches("apple.c"), urlMessage)
    XCTAssertFalse(basicHttpUrlRegex.matches("www.apple.c"), urlMessage)

    XCTAssertFalse(basicHttpUrlRegex.matches("https:/apple.com"), urlMessage)
    XCTAssertFalse(basicHttpUrlRegex.matches("https://apple.c/"), urlMessage)
    XCTAssertFalse(basicHttpUrlRegex.matches("https//apple.com/support"), urlMessage)
    XCTAssertFalse(basicHttpUrlRegex.matches("https://www.apple_com/support"), urlMessage)

    XCTAssertFalse(basicHttpUrlRegex.matches("http://apple=com"), urlMessage)
    XCTAssertFalse(basicHttpUrlRegex.matches("http://Apple.com/"), urlMessage)
    XCTAssertFalse(basicHttpUrlRegex.matches("http://-pple.com/support"), urlMessage)
    XCTAssertFalse(basicHttpUrlRegex.matches("htp://www.apple.com/support"), urlMessage)
  }
}

