//
//  HeadTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import XCTest
@testable import ffn_dl

final class HeadTests: XCTestCase {
  // SwiftSoup generates the missing head
  func DEACTIVATED_testIsNilWhenMissing() {
    let html = "test"

    let doc = Document.parse(html: html)!

    XCTAssertNil(doc.head, "Head should be nil")
  }

  func testSuccessWhenPresent() {
    let html = "<html><head></head></html>"

    let doc = Document.parse(html: html)!

    XCTAssertNoThrow(doc.head!, "Getting the head from a valid document should not throw")
  }

  func testEqualWhenParsingSameHTML() {
    let html = "<html><head></head></html>"

    let doc1 = Document.parse(html: html)!
    let doc2 = Document.parse(html: html)!

    XCTAssertEqual(doc1.head!, doc2.head!, "Heads should be equal")
  }

  func testNotEqualWhenParsingDifferentHTML() {
    let html1 = "<html><head></head></html>"
    let html2 = "<html><head><title></title></head></html>"

    let doc1 = Document.parse(html: html1)!
    let doc2 = Document.parse(html: html2)!

    XCTAssertNotEqual(doc1.head!, doc2.head!, "Heads should be different")
  }

  func testFullHTMLIsAsExpectedWhenParsingValidHTML() {
    let html = "<html><head><title>Title</title></head></html>"
    let expected = "<head><title>Title</title></head>"

    let doc = Document.parse(html: html)!
    let head = doc.head!
    let minifiedHTML = head.html.replacingOccurrences(
      of: "\n+ *",
      with: "",
      options: .regularExpression)

    XCTAssertEqual(minifiedHTML, expected, "HTML should be equal")
  }

  func testInnerHTMLIsAsExpectedWhenParsingValidHTML() {
    let html = "<html><head><title>Title</title></head></html>"
    let expected = "<title>Title</title>"

    let doc = Document.parse(html: html)!
    let head = doc.head!
    let minifiedHTML = head.innerHTML.replacingOccurrences(
      of: "\n+ *",
      with: "",
      options: .regularExpression)

    XCTAssertEqual(minifiedHTML, expected, "HTML should be equal")
  }
}
