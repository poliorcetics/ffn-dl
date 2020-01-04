//
//  DocumentTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import XCTest
@testable import ffn_dl

final class DocumentTests: XCTestCase {
  // Deactivated because I have not managed to make SwiftSoup throw an error
  // when parsing invalid HTML
  func DEACTIVATED_testParseReturnsNilOnInvalidHTMLString() {
    let invalidHTML = "<body><html></p/></body></head>"

    XCTAssertNil(Document.parse(html: invalidHTML), "Invalid HTML should make parsing throw")
  }

  func testParseSuccessOnValidHTMLString() {
    let html = "<html><head></head><body></body></html>"

    XCTAssertNotNil(Document.parse(html: html))
  }

  func testDocumentsAreEqualWhenParsingSameHTML() {
    let html = "<html><head></head><body></body></html>"

    let doc1 = Document.parse(html: html)!
    let doc2 = Document.parse(html: html)!

    XCTAssertEqual(doc1, doc2, "Documents parsed from the same HTML should be equal")
  }

  func testDocumentsAreNotEqualWhenParsingDifferentHTML() {
    let html1 = "<html><head></head><body></body></html>"
    let html2 = "<html><head></head><body><p></p></body></html>"

    let doc1 = Document.parse(html: html1)!
    let doc2 = Document.parse(html: html2)!

    XCTAssertNotEqual(doc1, doc2, "Documents parsed from different HTMLs should be different")
  }

  // MARK: - Full HTML

  func testFullHTMLIsCorrectOnValidHTML() {
    let html = "<html><head></head><body></body></html>"

    let doc = Document.parse(html: html)!

    // Ensuring the ouput is not prettyfied
    let outerHTML = doc.html.replacingOccurrences(
      of: "\n* *",
      with: "",
      options: .regularExpression)
    XCTAssertEqual(outerHTML, html, "HTMLs should be equal")
  }

  // MARK: - Inner HTML

  func testInnerHTMLisCorrectOnValidHTML() {
    let html = "<html><head></head><body></body></html>"
    let expected = "<head></head><body></body>"

    let doc = Document.parse(html: html)!

    // Ensuring the ouput is not prettyfied
    let innerHTML = doc.innerHTML.replacingOccurrences(
      of: "\n* *",
      with: "",
      options: .regularExpression)
    XCTAssertEqual(innerHTML, expected, "HTMLs should be equal")
  }
}
