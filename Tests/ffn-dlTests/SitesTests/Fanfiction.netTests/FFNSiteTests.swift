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

    let expected = URL(string: "https://www.fanfiction.net/s/13342536/1/The-devil-and-MISTER-Jones")!

    XCTAssertEqual(FFNSite.findCanonicalUrl(in: doc.head!), expected)
  }

  func testAuthorFinderReturnsNilOnWrongHTML() {
    let doc = Document.parse(html: "<html><head></head><body></body></html>")!

    XCTAssertNil(FFNSite.authorFinder.findURL(doc))
    XCTAssertNil(FFNSite.authorFinder.findName(doc))
  }

  func testAuthorFinderReturnsCorrectlyOnOkHTML() {
    let fileContent = try! String(contentsOfFile: "\(pathToTestDir)/complexValidHTMLTestFile.html")
    let doc = Document.parse(html: fileContent)!

    let expectedURL = URL(string: "https://www.fanfiction.net/u/1612344/mscatmoon")!
    let expectedName = "mscatmoon"

    XCTAssertEqual(FFNSite.authorFinder.findURL(doc), expectedURL)
    XCTAssertEqual(FFNSite.authorFinder.findName(doc), expectedName)
  }

  func testChapterFinderReturnsNilOnWrongHTML() {
    let doc = Document.parse(html: "<html><head></head><body></body></html>")!

    XCTAssertNil(FFNSite.chapterFinder.findURL(doc))
    XCTAssertEqual(FFNSite.chapterFinder.findTitle(doc), "")
    XCTAssertNil(FFNSite.chapterFinder.findContent(doc))
  }

  func testChapterFinderReturnsCorrectlyOnOkHTMLWithNoTitle() {
    let fileContent = try! String(contentsOfFile: "\(pathToTestDir)/complexValidHTMLTestFile.html")
    let doc = Document.parse(html: fileContent)!

    let expectedURL = URL(string: "https://www.fanfiction.net/s/13342536/1/The-devil-and-MISTER-Jones")!
    let expectedTitle = "The devil and MISTER Jones"
    let expectedContentLength = 4609

    XCTAssertEqual(FFNSite.chapterFinder.findURL(doc), expectedURL)
    XCTAssertEqual(FFNSite.chapterFinder.findTitle(doc), expectedTitle)
    XCTAssertEqual(FFNSite.chapterFinder.findContent(doc)?.count, expectedContentLength)
  }

  func testChapterFinderReturnsCorrectlyOnOkHTMLWithTitle() {
    let fileContent = try! String(contentsOfFile: "\(pathToTestDir)/multiChapterFic.html")
    let doc = Document.parse(html: fileContent)!

    let expectedURL = URL(string: "https://www.fanfiction.net/s/9443327/1/A-Third-Path-to-the-Future")!
    let expectedTitle = "1. A Stranger in an even Stranger Land"
    let expectedContentLength = 60503

    XCTAssertEqual(FFNSite.chapterFinder.findURL(doc), expectedURL)
    XCTAssertEqual(FFNSite.chapterFinder.findTitle(doc), expectedTitle)
    XCTAssertEqual(FFNSite.chapterFinder.findContent(doc)?.count, expectedContentLength)
  }

  func testUniverseFinderReturnsNilOnWrongHTML() {
    let doc = Document.parse(html: "<html><head></head><body></body></html>")!

    XCTAssertNil(FFNSite.universeFinder.findURL(doc))
    XCTAssertNil(FFNSite.universeFinder.findName(doc))
    XCTAssertFalse(FFNSite.universeFinder.findCrossover(doc))
  }

  func testAuthorFinderReturnsCorrectlyOnNonCrossoverUniverseHTML() {
    let fileContent = try! String(contentsOfFile: "\(pathToTestDir)/singleChapterFic.html")
    let doc = Document.parse(html: fileContent)!

    let expectedURL = URL(string: "https://www.fanfiction.net/book/Harry-Potter/")
    let expectedName = "Harry Potter"
    let expectedCrossover = false

    XCTAssertEqual(FFNSite.universeFinder.findURL(doc), expectedURL)
    XCTAssertEqual(FFNSite.universeFinder.findName(doc), expectedName)
    XCTAssertEqual(FFNSite.universeFinder.findCrossover(doc), expectedCrossover)
  }

  func testAuthorFinderReturnsCorrectlyOnCrossoverUniverseHTML() {
    let fileContent = try! String(contentsOfFile: "\(pathToTestDir)/multiChapterFic.html")
    let doc = Document.parse(html: fileContent)!

    let expectedURL = URL(string: "https://www.fanfiction.net/Harry-Potter_and_Marvel_Crossovers/224/357/")!
    let expectedName = "Harry Potter + Marvel Crossover"
    let expectedCrossover = true

    XCTAssertEqual(FFNSite.universeFinder.findURL(doc), expectedURL)
    XCTAssertEqual(FFNSite.universeFinder.findName(doc), expectedName)
    XCTAssertEqual(FFNSite.universeFinder.findCrossover(doc), expectedCrossover)
  }
}
