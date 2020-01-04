//
//  FFNSite.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-04.
//  Copyright © 2020 Alexis Bourget. All rights reserved.
//

import XCTest
@testable import ffn_dl

final class FFNSiteTests: XCTestCase {
  func testNameIsCorrect() {
    XCTAssertEqual(FFNSite.name, "Fanfiction.net")
  }

  func testMainURLIsCorrect() {
    let mainURL = URL(string: "https://www.fanfiction.net")!

    XCTAssertEqual(FFNSite.mainURL, mainURL)
  }

  func testMobileURLIsCorrect() {
    let mobileURL = URL(string: "https://m.fanfiction.net")!

    XCTAssertEqual(FFNSite.mobileURL, mobileURL)
  }

  func testMainURLStringIsCorrect() {
    let mainURLString = "https://www.fanfiction.net"

    XCTAssertEqual(FFNSite.mainURLString, mainURLString)
  }

  func testMobileURLStringIsCorrect() {
    let mobileURLString = "https://m.fanfiction.net"

    XCTAssertEqual(FFNSite.mobileURLString, mobileURLString)
  }

  func testSiteRegexIsCorrect() {
    let siteRegex = NSRegularExpression("https://(m|www).fanfiction.net(/.*)?")

    XCTAssertEqual(FFNSite.siteRegex, siteRegex)
  }

  func testConversionFromInvalidURLToMainURLReturnsNil() {
    let url = URL(string: "https://archiveofourown.org")!

    XCTAssertNil(FFNSite.convertToMainURL(from: url))
  }

  func testConversionFromAlreadyValidURLToMainURLReturnsCorrectly() {
    let url = URL(string: "https://www.fanfiction.net/s/12125300/49/")!

    let result = FFNSite.convertToMainURL(from: url)
    let expected = URL(string: "https://www.fanfiction.net/s/12125300/49/")!

    XCTAssertEqual(result, expected)
  }

  func testConversionFromNotAlreadyValidURLToMainURLReturnsCorrectly() {
    let url = URL(string: "https://m.fanfiction.net/s/12125300/49/")!

    let result = FFNSite.convertToMainURL(from: url)
    let expected = URL(string: "https://www.fanfiction.net/s/12125300/49/")!

    XCTAssertEqual(result, expected)
  }

  func testFindCanonicalURLReturnsNilWhenNotPresent() {
    let doc = Document.parse(html: "<html><head></head><body></body></html>")!

    let head = doc.head!

    XCTAssertNil(FFNSite.findCanonicalUrl(in: head))
  }

  func testFindCanonicalURLReturnsCorrectURLWhenPresent() {
    let fileContent = try! String(contentsOfFile: "\(pathToTestDir)/complexValidHTMLTestFile.html")

    let doc = Document.parse(html: fileContent)!
    let head = doc.head!

    let expected = URL(string: "https://www.fanfiction.net/s/13342536/1/The-devil-and-MISTER-Jones")
    XCTAssertEqual(FFNSite.findCanonicalUrl(in: head), expected)
  }
}
