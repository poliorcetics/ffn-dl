//
//  File.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2020-01-05.
//  See LICENSE at the root of the project.
//

import XCTest
@testable import ffn_dl

fileprivate enum MockSiteWithDefaultMobileURL: Site {
  static let name = "Ultimate HP FFN"
  static let mainURL = URL(string: "https://ultimatehpfanfiction.com")!
  static let regex = NSRegularExpression("https://(?:www.)?ultimatehpfanfiction.com/.+?")

  // Default values, they are not tested here
  static let authorFinder = FFNSite.authorFinder
  static let chapterFinder = FFNSite.chapterFinder
  static let universeFinder = FFNSite.universeFinder
}

fileprivate enum MockSiteWithSpecificMobileURL: Site {
  static let name = "Fanfiction.net"
  static let mainURL = URL(string: "https://www.fanfiction.net")!
  static let mobileURL = URL(string: "https://m.fanfiction.net")!
  static let regex = NSRegularExpression("https://(m|www).fanfiction.net(/.*)?")

  // Default values, they are not tested here
  static let authorFinder = FFNSite.authorFinder
  static let chapterFinder = FFNSite.chapterFinder
  static let universeFinder = FFNSite.universeFinder
}

final class SiteTests: XCTestCase {
  func testMainAbsoluteString() {
    XCTAssertEqual(MockSiteWithDefaultMobileURL.mainURL.absoluteString,
                   MockSiteWithDefaultMobileURL.mainAbsoluteString)
    XCTAssertEqual(MockSiteWithSpecificMobileURL.mainURL.absoluteString,
                   MockSiteWithSpecificMobileURL.mainAbsoluteString)
  }

  func testDefaultMobileURLIsMainURL() {
    XCTAssertEqual(MockSiteWithDefaultMobileURL.mainURL, MockSiteWithDefaultMobileURL.mobileURL)
  }

  func testSpecificMobileURLIsNotMainURL() {
    XCTAssertNotEqual(MockSiteWithSpecificMobileURL.mainURL,
                      MockSiteWithSpecificMobileURL.mobileURL)
  }

  func testMobileAbsoluteString() {
    XCTAssertEqual(MockSiteWithDefaultMobileURL.mobileURL.absoluteString,
                   MockSiteWithDefaultMobileURL.mobileAbsoluteString)
    XCTAssertEqual(MockSiteWithSpecificMobileURL.mobileURL.absoluteString,
                   MockSiteWithSpecificMobileURL.mobileAbsoluteString)
  }

  func testConvertToMainURLSucceedsOnMainURL() {
    let url = URL(string: "https://ultimatehpfanfiction.com/susan/air")!

    XCTAssertEqual(MockSiteWithDefaultMobileURL.convertToMainURL(url), url)
  }

  func testConvertToMainURLSuccessOnMobileURL() {
    let url = URL(string: "https://m.fanfiction.net/s/3333378/1/")!

    let expected = URL(string: "https://www.fanfiction.net/s/3333378/1/")!

    XCTAssertEqual(MockSiteWithSpecificMobileURL.convertToMainURL(url), expected)
  }

  func testFailureToConvertToMailURLReturnsNil() {
    let url = URL(string: "https://m.fanfiction.net/s/3333378/1/")!
    XCTAssertNil(MockSiteWithDefaultMobileURL.convertToMainURL(url))

    let url2 = URL(string: "https://ultimatehpfanfiction.com/susan/air")!
    XCTAssertNil(MockSiteWithSpecificMobileURL.convertToMainURL(url2))
  }
}
