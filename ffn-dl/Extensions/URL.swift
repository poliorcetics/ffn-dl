//
//  URL.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

// MARK: - Getting the content
extension URL {
  func getContent() -> String? {
    return try? String(contentsOf: self, encoding: .utf8)
  }

  func getDocument() -> Document? {
    guard let pageText = getContent(),
          let doc = Document.parse(html: pageText)
    else {
      return nil
    }
    return doc
  }
}
