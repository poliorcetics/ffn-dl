//
//  Document.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import Foundation
import SwiftSoup

/// A HTML Document.
/// HTML Tag: `<html>`
///
/// Create one using the `parse(html:)` function.
public final class Document: Component {
  private let doc: SwiftSoup.Document
  
  public override var innerHTML: String {
    "\(head?.html ?? "")\(body?.html ?? "")"
  }
  
  public lazy private(set) var head: Head? = {
    guard let head = doc.head() else {
      return nil
    }
    return Head(head: head)
  }()
  
  public lazy private(set) var body: Body? = {
    guard let body = doc.body() else {
      return nil
    }
    return Body(body: body)
  }()

  private init(doc: SwiftSoup.Document) {
    self.doc = doc
    super.init(elem: doc)
  }
}

// MARK: - Parsing
public extension Document {
  /// Attempts to make a Document out of a String. Returns `nil` on failure
  /// - Parameter html: the string to parse, expected to be valid HTML.
  static func parse(html: String) -> Document? {
    guard let doc = try? SwiftSoup.parse(html) else {
      return nil
    }
    return Document(doc: doc)
  }
}
