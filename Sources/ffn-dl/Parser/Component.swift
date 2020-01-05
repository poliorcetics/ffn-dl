//
//  Component.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import Foundation
import SwiftSoup

/// A non-specific HTML Component.
///
/// This type exist to be an interface between the HTML parsing code and the ffn-dl code,
/// allowing behind-the-scene changes.
public class Component {
  private let elem: Element
  
  /// The encompassing HTML of the component.
  ///
  /// Example:
  ///
  /// Element: `<div><p>Text</p></div>`
  /// HTML: `<div><p>Text</p></div>`
  public lazy private(set) var html: String = (try? elem.outerHtml()) ?? ""

  /// The HTML inside the component.
  ///
  /// Example:
  ///
  /// Element: `<div><p>Text</p></div>`
  /// Inner HTML: `<p>Text</p>`
  ///
  /// Element: `<p>Text</p>`
  /// Inner HTML: `Text`
  public lazy private(set) var innerHTML: String = (try? elem.html()) ?? ""
  
  /// The text inside this component and all the nested sub-components.
  ///
  /// If there are no sub-components, this is equal to calling
  /// `.ownText`.
  ///
  /// Empty string if no text is found.
  public lazy private(set) var fullText: String = (try? elem.text()) ?? ""
  
  /// The owned by this component only, ignoring the nested sub-components.
  ///
  /// Empty string if no text is found.
  public lazy private(set) var ownText: String = elem.ownText()

  internal init(elem: Element) {
    self.elem = elem
  }
}

public extension Component {
  // MARK: - Public functions

  /// Performs a search in the current ComponentProtocol
  /// for the given CSS query.
  ///
  /// - Returns: All matching components separately, even if they are nested
  func select(withCSSQuery query: String) -> [Component] {
    let elements = try? elem.select(query)
    let elementsArray = elements?.array() ?? []
    let components = elementsArray.map { Component(elem: $0) }
    return components
  }
  
  /// Performs a search in the current ComponentProtocol
  /// for the given CSS query.
  ///
  /// - Returns: The first matching component, if any
  func selectFirst(withCSSQuery query: String) -> Component? {
    select(withCSSQuery: query).first
  }
  
  /// Returns `true` if the attribute is present, `false` if not.
  ///
  /// **Case-insensitive**.
  func hasAttribute(withKey key: String) -> Bool {
    elem.hasAttr(key)
  }

  /// Returns the content of the given attribute, if present,
  /// else returns `nil`.
  ///
  /// If present multiple times, returns the value
  /// of the **last instance**.
  ///
  /// **Case-insensitive**.
  func attributeContent(withKey key: String) -> String? {
    guard hasAttribute(withKey: key) else {
      return nil
    }
    return try? elem.attr(key)
  }
}

extension Component: Equatable {
  // MARK: - Equatable
  
  public static func ==(lhs: Component, rhs: Component) -> Bool {
    lhs.html.hashValue == rhs.html.hashValue
  }
}
