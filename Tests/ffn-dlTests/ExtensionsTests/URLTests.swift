//
//  URLTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import XCTest
@testable import ffn_dl

final class URLTests: XCTestCase {
  // MARK: - Local getContent Tests
  func testGetContentSuccessOnValidLocalFileWithSingleLine() {
    let singleLineContentURL = URL(fileURLWithPath: "\(pathToTestDir)/contentOnASingleLine.txt")
    let expectedSingleLineContent = "content on a single line\n"

    let content = singleLineContentURL.getContent()!

    XCTAssertEqual(content, expectedSingleLineContent, "The contents should be equals")
  }

  func testGetContentSuccessOnValidLocalFileWithMultipleLines() {
    let multipleLinesContentURL = URL(fileURLWithPath: "\(pathToTestDir)/contentOnMultipleLines.txt")
    let expectedMultipleLinesContent = "content\non\nmultiple\nlines\n"

    let content = multipleLinesContentURL.getContent()!
    XCTAssertEqual(content, expectedMultipleLinesContent, "The contents should be equals")
  }

  func testGetContentReturnsNilOnInvalidLocalFile() {
    let invalidFileURL = URL(fileURLWithPath: "/")

    XCTAssertNil(invalidFileURL.getContent())
  }

  func testGetContentReturnsNilOnMissingLocalFile() {
    let invalidFileURL = URL(fileURLWithPath: "doNotExist.txt")

    XCTAssertNil(invalidFileURL.getContent())
  }

  // MARK: - getDocument Tests
  // No test on the content is done because those are not relevant here
  // See the tests on `Document`
  func testGetDocumentSuccessWithSimpleValidHTMLFile() throws {
    let HTMLFileURL = URL(fileURLWithPath: "\(pathToTestDir)/simpleValidHTMLTestFile.html")

    XCTAssertNotNil(HTMLFileURL.getDocument())
  }

  func testGetDocumentSuccessWithComplexValidHTMLFile() {
    let HTMLFileURL = URL(fileURLWithPath: "\(pathToTestDir)/complexValidHTMLTestFile.html")

    XCTAssertNotNil(HTMLFileURL.getDocument())
  }
}
