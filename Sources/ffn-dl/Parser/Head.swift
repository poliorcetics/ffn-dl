//
//  Head.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import Foundation
import SwiftSoup

/// A Head HTML Component.
/// HTML Tag: `<head>`
public final class Head: Component {
  internal init(head: Element) {
    super.init(elem: head)
  }
}
