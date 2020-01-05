//
//  URL.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import Foundation

internal extension URL {
  /// Attempts to get the content stored at `self`, with `UTF-8` encoding.
  ///
  /// Returns `nil` on failure.
  func getContent() -> String? {
    return try? String(contentsOf: self, encoding: .utf8)
  }

  /// Attempts to make a Document out of the content at `self`, using `UTF-8`.
  ///
  /// Returns `nil` on failure.
  func getDocument() -> Document? {
    guard let pageText = getContent(),
          let doc = Document.parse(html: pageText)
    else {
      return nil
    }
    return doc
  }
}
