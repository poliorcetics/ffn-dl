//
//  ComponentTests.swift
//  SwiftlyFFNTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import XCTest
@testable import ffn_dl

final class ComponentTests: XCTestCase {
  // MARK: HTML
  
  func testHTMLGetterIsAsExpectedWhenNoHTMLWasGiven() {
    let text = "text"
    let doc = Document.parse(html: text)!
    
    let html = doc.html.replacingOccurrences(
      of: "\n* *",
      with: "",
      options: .regularExpression
    )
    let expected = "<html><head></head><body>text</body></html>"
    
    XCTAssertEqual(html, expected, "Auto-generated HTML should be as expected")
  }
  
  func testHTMLGetterIsAsExpectedWhenPartialHTMLWasGiven() {
    let text = "<html><body>text</body></html>"
    let doc = Document.parse(html: text)!
    
    let html = doc.html.replacingOccurrences(
      of: "\n* *",
      with: "",
      options: .regularExpression
    )
    let expected = "<html><head></head><body>text</body></html>"
    
    XCTAssertEqual(html, expected, "Auto-generated HTML should be as expected")
  }
  
  func testHTMLGetterIsAsExpectedWhenFullHTMLWasGiven() {
    let text = "<html><head></head><body><p>text</p></body></html>"
    let doc = Document.parse(html: text)!
    
    let html = doc.html.replacingOccurrences(
      of: "\n* *",
      with: "",
      options: .regularExpression
    )
    let expected = "<html><head></head><body><p>text</p></body></html>"
    
    XCTAssertEqual(html, expected, "Auto-generated HTML should be as expected")
  }
  
  // MARK: InnerHTML
  
  func testInnerHTMLIsAsExpectedWhenNoHTMLWasGiven() {
    let text = "text"
    let doc = Document.parse(html: text)!
    
    let html = doc.innerHTML.replacingOccurrences(
      of: "\n* *",
      with: "",
      options: .regularExpression
    )
    let expected = "<head></head><body>text</body>"
    
    XCTAssertEqual(html, expected, "Auto-generated HTML should be as expected")
  }

  func testInnerHTMLIsAsExpectedWhenPartialHTMLWasGiven() {
    let text = "<body>text</body>"
    let doc = Document.parse(html: text)!
    
    let html = doc.innerHTML.replacingOccurrences(
      of: "\n* *",
      with: "",
      options: .regularExpression
    )
    let expected = "<head></head><body>text</body>"
    
    XCTAssertEqual(html, expected, "Auto-generated HTML should be as expected")
  }
  
  func testInnerHTMLIsAsExpectedWhenFullHTMLWasGiven() {
    let text = "<html><head></head><body><p>text</p></body></html>"
    let doc = Document.parse(html: text)!
    
    let html = doc.innerHTML.replacingOccurrences(
      of: "\n* *",
      with: "",
      options: .regularExpression
    )
    let expected = "<head></head><body><p>text</p></body>"
    
    XCTAssertEqual(html, expected, "Auto-generated HTML should be as expected")
  }
  
  func testInnerHTMLOfSimpleComponentIsAsExpected() {
    let text = "<html><head></head><body><p>text</p></body></html>"
    let doc = Document.parse(html: text)!
    
    let html = doc
      .selectFirst(withCSSQuery: "p")?
      .innerHTML
      .replacingOccurrences(
        of: "\n* *",
        with: "",
        options: .regularExpression
    )
    let expected = "text"
    
    XCTAssertEqual(html, expected, "Auto-generated HTML should be as expected")
  }
  
  // MARK: Select
  
  func testSelectEmptyQueryReturnsEmptyArray() {
    let html = "<body><p></p></body>"
    let doc = Document.parse(html: html)!

    let components = doc.select(withCSSQuery: "")

    XCTAssertTrue(components.isEmpty, "Components should be empty")
  }

  func testSelectInvalidQueryReturnsEmptyArray() {
    let html = "<body><p></p></body>"
    let doc = Document.parse(html: html)!

    let components = doc.select(withCSSQuery: "test")

    XCTAssertTrue(components.isEmpty, "Components should be empty")
  }

  func testSelectValidButMissingQueryReturnsEmptyArray() {
    let html = "<body><p></p></body>"
    let doc = Document.parse(html: html)!

    let components = doc.select(withCSSQuery: "a")

    XCTAssertTrue(components.isEmpty, "Components should be empty")
  }

  func testSelectValidAndPresentSimpleQueryReturnsCorrectlyFilledArray() {
    let html = "<body><p></p></body>"
    let doc = Document.parse(html: html)!

    let components = doc.select(withCSSQuery: "p")
    let firstComponentFullHTML = components
      .first?
      .html
      .replacingOccurrences(of: "\n* *",
                            with: "",
                            options: .regularExpression)

    XCTAssertEqual(components.count, 1, "There should be one component")
    XCTAssertEqual(firstComponentFullHTML, "<p></p>", "HTML should be as expected")
  }

  func testSelectValidAndPresentComplexQueryReturnsCorrectlyFilledArray() {
    let html = #"<body><p class="main"></p><p class="test"></p></body>"#
    let doc = Document.parse(html: html)!

    let components = doc.select(withCSSQuery: "p.main")
    let firstComponentFullHTML = components
      .first?
      .html
      .replacingOccurrences(of: "\n+ *",
                            with: "",
                            options: .regularExpression)

    XCTAssertEqual(components.count, 1, "There should be one component")
    XCTAssertEqual(firstComponentFullHTML,
                   #"<p class="main"></p>"#,
                   "HTML should be as expected")
  }

  func testSelectWhenQueryIsPresentReturnsMultipleNonRelatedComponents() {
    let html = #"<body><p class="main"></p><p class="test"></p></body>"#
    let doc = Document.parse(html: html)!

    let components = doc.select(withCSSQuery: "p")

    XCTAssertEqual(components.count, 2, "There should be two components")
  }

  func testSelectWhenQueryIsPresentReturnsMultipleRelatedComponents() {
    let html = "<body><div><div></div></div></body>"
    let doc = Document.parse(html: html)!

    let components = doc.select(withCSSQuery: "div")

    XCTAssertEqual(components.count, 2, "There should be two components")
  }
  
  // MARK: SelectFirst
  
  func testSelectFirstEmptyQueryReturnsEmptyArray() {
    let html = "<body><p></p></body>"
    let doc = Document.parse(html: html)!

    let component = doc.selectFirst(withCSSQuery: "")

    XCTAssertNil(component)
  }

  func testSelectFirstInvalidQueryReturnsEmptyArray() {
    let html = "<body><p></p></body>"
    let doc = Document.parse(html: html)!

    let component = doc.selectFirst(withCSSQuery: "test")

    XCTAssertNil(component)
  }

  func testSelectFirstValidButMissingQueryReturnsEmptyArray() {
    let html = "<body><p></p></body>"
    let doc = Document.parse(html: html)!

    let component = doc.selectFirst(withCSSQuery: "a")

    XCTAssertNil(component)
  }

  func testSelectFirstValidAndPresentSimpleQueryReturnsCorrectlyFilledArray() {
    let html = "<body><p></p></body>"
    let doc = Document.parse(html: html)!

    let component = doc.selectFirst(withCSSQuery: "p")
    let componentFullHTML = component?
      .html
      .replacingOccurrences(of: "\n* *",
                            with: "",
                            options: .regularExpression)

    XCTAssertEqual(componentFullHTML, "<p></p>")
  }

  func testSelectFirstValidAndPresentComplexQueryReturnsCorrectlyFilledArray() {
    let html = #"<body><p class="main"></p><p class="test"></p></body>"#
    let doc = Document.parse(html: html)!

    let component = doc.selectFirst(withCSSQuery: "p.main")
    let componentFullHTML = component?
      .html
      .replacingOccurrences(of: "\n+ *",
                            with: "",
                            options: .regularExpression)

    XCTAssertEqual(componentFullHTML, #"<p class="main"></p>"#)
  }

  func testSelectFirstWhenQueryIsPresentReturnsMultipleNonRelatedComponents() {
    let html = #"<body><p class="main"></p><p class="test"></p></body>"#
    let doc = Document.parse(html: html)!

    let component = doc.selectFirst(withCSSQuery: "p")
    let componentFullHTML = component?
      .html
      .replacingOccurrences(of: "\n+ *",
                            with: "",
                            options: .regularExpression)

    XCTAssertEqual(componentFullHTML, #"<p class="main"></p>"#,
                   "The HTML should correspond to the first paragraph")
  }
  
  // MARK: HasAttribute

  func testHasAttributeReturnsFalseWhenMissing() {
    let html = #"<body class="test"></body>"#
    let doc = Document.parse(html: html)!

    let body = doc.body!
    let attrIsPresent = body.hasAttribute(withKey: "id")

    XCTAssertFalse(attrIsPresent, "Body has no attribute `id` here")
  }

  func testHasAttributeReturnsTrueWhenPresent() {
    let html = #"<body class="test"></body>"#
    let doc = Document.parse(html: html)!

    let body = doc.body!
    let attrIsPresent = body.hasAttribute(withKey: "class")

    XCTAssertTrue(attrIsPresent, "Body has the `class` attribute here")
  }

  // MARK: Attribute
  
  func testAttributeReturnsNilWhenMissing() {
    let html = #"<body class="test"></body>"#
    let doc = Document.parse(html: html)!

    let body = doc.body!
    let attrContent = body.attributeContent(withKey: "id")

    XCTAssertNil(attrContent, "Body has no attribute `id` here")
  }

  func testAttributeReturnsContentWhenPresent() {
    let html = #"<body id="test"></body>"#
    let doc = Document.parse(html: html)!

    let body = doc.body!
    let attrContent = body.attributeContent(withKey: "id")

    XCTAssertEqual(attrContent, "test", "Body's ID should be `test`")
  }

  func testAttributeReturnsContentOfLastInstanceWhenPresentMutlipleTimes() {
      let html = #"<body id="test" id="test2"></body>"#
      let doc = Document.parse(html: html)!

      let body = doc.body!
      let attrContent = body.attributeContent(withKey: "id")

      XCTAssertEqual(attrContent, "test2", "Body's ID should be `test2`, the last instance")
    }
  
  // MARK: FullText
  
  func testFullTextIsEmptyWhenNoHTMLIsGiven() {
    let html = ""
    let doc = Document.parse(html: html)!
    
    let fullText = doc.fullText
    
    XCTAssertEqual(fullText, "")
  }
  
  func testFullTextIsEmptyWhenNoTextIsPresent() {
    let html = "<p></p>"
    let doc = Document.parse(html: html)!
    
    let fullText = doc.fullText
    
    XCTAssertEqual(fullText, "")
  }
  
  func testFullTextIsEmptyWhenNoTextIsPresent2() {
    let html = "<img/>"
    let doc = Document.parse(html: html)!
    
    let fullText = doc.fullText
    
    XCTAssertEqual(fullText, "")
  }
  
  func testFullTextIsCorrectWhenTextIsPresent() {
    let html = "text"
    let doc = Document.parse(html: html)!
    
    let fullText = doc.fullText
    
    XCTAssertEqual(fullText, "text")
  }
  
  func testFullTextIsCorrectWhenHTMLIsPresent() {
    let html = "<p>text</p><p>test2</p>"
    let doc = Document.parse(html: html)!
    
    let fullText = doc.fullText
    
    XCTAssertEqual(fullText, "text test2")
  }
  
  func testFullTextIsCorrectWhenHTMLIsPresent2() {
    let html = "<p>text</p><p>test2</p>"
    let doc = Document.parse(html: html)!
    
    let firstParagraph = doc.selectFirst(withCSSQuery: "p")!
    let fullText = firstParagraph.fullText
    
    XCTAssertEqual(fullText, "text")
  }
  
  func testFullTextIsCorrectWhenHTMLIsNested() {
    let html = "<p>text <a>link</a></p><p>test2</p>"
    let doc = Document.parse(html: html)!
    
    let fullText = doc.fullText
    
    XCTAssertEqual(fullText, "text link test2")
  }
  
  func testFullTextIsCorrectWhenHTMLIsNested2() {
    let html = "<p>text <a>link</a></p><p>test2</p>"
    let doc = Document.parse(html: html)!
    
    let firstParagraph = doc.selectFirst(withCSSQuery: "p")!
    let fullText = firstParagraph.fullText
    
    XCTAssertEqual(fullText, "text link")
  }
  
  // MARK: OwnText
  
  func testOwnTextIsEmptyWhenNoHTMLIsGiven() {
    let html = ""
    let doc = Document.parse(html: html)!
    
    let ownText = doc.ownText
    
    XCTAssertEqual(ownText, "")
  }
  
  func testOwnTextIsEmptyWhenNoTextIsPresent() {
    let html = "<p></p>"
    let doc = Document.parse(html: html)!
    
    let ownText = doc.ownText
    
    XCTAssertEqual(ownText, "")
  }
  
  func testOwnTextIsEmptyWhenNoTextIsPresent2() {
    let html = "<img/>"
    let doc = Document.parse(html: html)!
    
    let ownText = doc.ownText
    
    XCTAssertEqual(ownText, "")
  }
  
  func testOwnTextIsCorrectWhenTextIsPresent() {
    let html = "text"
    let doc = Document.parse(html: html)!
    
    let ownText = doc.ownText
    
    XCTAssertEqual(ownText, "")
  }
  
  func testOwnTextIsCorrectWhenHTMLIsPresent() {
    let html = "<p>text</p><p>test2</p>"
    let doc = Document.parse(html: html)!
    
    let ownText = doc.ownText
    
    XCTAssertEqual(ownText, "")
  }
  
  func testOwnTextIsCorrectWhenHTMLIsPresent2() {
    let html = "<p>text</p><p>test2</p>"
    let doc = Document.parse(html: html)!
    
    let firstParagraph = doc.selectFirst(withCSSQuery: "p")!
    let ownText = firstParagraph.ownText
    
    XCTAssertEqual(ownText, "text")
  }
  
  func testOwnTextIsCorrectWhenHTMLIsNested() {
    let html = "<p>text <a>link</a></p><p>test2</p>"
    let doc = Document.parse(html: html)!
    
    let ownText = doc.ownText
    
    XCTAssertEqual(ownText, "")
  }
  
  func testOwnTextIsCorrectWhenHTMLIsNested2() {
    let html = "<p>text <a>link</a></p><p>test2</p>"
    let doc = Document.parse(html: html)!
    
    let firstParagraph = doc.selectFirst(withCSSQuery: "p")!
    let ownText = firstParagraph.ownText
    
    XCTAssertEqual(ownText, "text")
  }
  
  func testOwnTextEqualsFullTextForEmptyHTML() {
    let html = ""
    let doc = Document.parse(html: html)!
    
    XCTAssertEqual(doc.fullText, doc.ownText)
  }
  
  func testOwnTextEqualsFullTextForSimpleEmptyHTML() {
    let html = "<p><p>"
    let doc = Document.parse(html: html)!
    
    XCTAssertEqual(doc.fullText, doc.ownText)
  }
  
  func testOwnTextEqualsFullTextForSimpleFilledHTML() {
    let html = "<p>text<p>"
    let doc = Document.parse(html: html)!
    
    let par = doc.selectFirst(withCSSQuery: "p")!
    
    XCTAssertEqual(par.fullText, par.ownText)
  }
  
  func testOwnTextDiffersFullTextForFilledHTMLUsingFullDocument() {
    let html = "<p>text<p>"
    let doc = Document.parse(html: html)!
    
    XCTAssertNotEqual(doc.fullText, doc.ownText)
  }
}
