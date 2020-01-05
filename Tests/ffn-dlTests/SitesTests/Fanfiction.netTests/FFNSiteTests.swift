//
//  FFNSiteTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-04.
//  See LICENSE at the root of the project.
//

import XCTest
@testable import ffn_dl

final class FFNSiteTests: XCTestCase {
  func testNameIsCorrect() {
    XCTAssertEqual(FFNSite.name, "Fanfiction.net")
  }

  func testMainURLIsCorrect() {
    XCTAssertEqual(FFNSite.mainURL, URL(string: "https://www.fanfiction.net")!)
  }

  func testMobileURLIsCorrect() {
    XCTAssertEqual(FFNSite.mobileURL, URL(string: "https://m.fanfiction.net")!)
  }

  func testMainAbsoluteStringIsCorrect() {
    XCTAssertEqual(FFNSite.mainAbsoluteString, "https://www.fanfiction.net")
  }

  func testMobileAbsoluteStringIsCorrect() {
    XCTAssertEqual(FFNSite.mobileAbsoluteString, "https://m.fanfiction.net")
  }

  func testRegexIsCorrect() {
    XCTAssertEqual(FFNSite.regex, NSRegularExpression("https://(m|www).fanfiction.net(/.*)?"))
  }

  func testConversionFromInvalidURLToMainURLReturnsNil() {
    XCTAssertNil(FFNSite.convertToMainURL(URL(string: "https://archiveofourown.org")!))
  }

  func testConversionFromAlreadyValidURLToMainURLReturnsCorrectly() {
    let url = URL(string: "https://www.fanfiction.net/s/12125300/49/")!

    let expected = URL(string: "https://www.fanfiction.net/s/12125300/49/")!

    XCTAssertEqual(FFNSite.convertToMainURL(url), expected)
  }

  func testConversionFromNotAlreadyValidURLToMainURLReturnsCorrectly() {
    let url = URL(string: "https://m.fanfiction.net/s/12125300/49/")!

    let expected = URL(string: "https://www.fanfiction.net/s/12125300/49/")!

    XCTAssertEqual(FFNSite.convertToMainURL(url), expected)
  }

  func testFindCanonicalURLReturnsNilWhenNotPresent() {
    let doc = Document.parse(html: "<html><head></head><body></body></html>")!

    XCTAssertNil(FFNSite.findCanonicalUrl(in: doc.head!))
  }

  func testFindCanonicalURLReturnsCorrectURLWhenPresent() {
    let fileContent = try! String(contentsOfFile: "\(pathToTestDir)/complexValidHTMLTestFile.html")
    let doc = Document.parse(html: fileContent)!

    let expected = URL(string: "https://www.fanfiction.net/s/13342536/1/The-devil-and-MISTER-Jones")

    XCTAssertEqual(FFNSite.findCanonicalUrl(in: doc.head!), expected)
  }
}
