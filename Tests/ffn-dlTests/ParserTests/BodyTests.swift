//
//  BodyTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import XCTest
@testable import ffn_dl

final class BodyTests: XCTestCase {
  // SwiftSoup generates the missing body
  func DEACTIVATED_testIsNilWhenMissing() {
    let html = "test"

    let doc = Document.parse(html: html)!

    XCTAssertNil(doc.body, "Body should be nil")
  }

  func testSuccessWhenPresent() {
    let html = "<html><body></body></html>"

    let doc = Document.parse(html: html)!

    XCTAssertNoThrow(doc.body!, "Getting the body from a valid document should not throw")
  }

  func testEqualWhenParsingSameHTML() {
    let html = "<html><body></body></html>"

    let doc1 = Document.parse(html: html)!
    let doc2 = Document.parse(html: html)!

    XCTAssertEqual(doc1.body!, doc2.body!, "Bodies should be equal")
  }

  func testNotEqualWhenParsingDifferentHTML() {
    let html1 = "<html><body></body></html>"
    let html2 = "<html><body><p></p></body></html>"

    let doc1 = Document.parse(html: html1)!
    let doc2 = Document.parse(html: html2)!

    XCTAssertNotEqual(doc1.body!, doc2.body!, "Bodies should be different")
  }

  func testFullHTMLIsAsExpectedWhenParsingValidHTML() {
    let html = "<html><body><p>Text</p></body></html>"
    let expected = "<body><p>Text</p></body>"

    let doc = Document.parse(html: html)!
    let body = doc.body!
    let minifiedHTML = body.html.replacingOccurrences(
      of: "\n+ *",
      with: "",
      options: .regularExpression)

    XCTAssertEqual(minifiedHTML, expected, "HTML should be equal")
  }

  func testInnerHTMLIsAsExpectedWhenParsingValidHTML() {
    let html = "<html><body><p>Text</p></body></html>"
    let expected = "<p>Text</p>"

    let doc = Document.parse(html: html)!
    let body = doc.body!
    let minifiedHTML = body.innerHTML.replacingOccurrences(
      of: "\n+ *",
      with: "",
      options: .regularExpression)

    XCTAssertEqual(minifiedHTML, expected, "HTML should be equal")
  }
}
