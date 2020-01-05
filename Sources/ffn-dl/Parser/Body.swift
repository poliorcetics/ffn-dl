//
//  Body.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import Foundation
import SwiftSoup

/// A Body HTML Component.
/// HTML Tag: `<body>`
public final class Body: Component {
  internal init(body: Element) {
    super.init(elem: body)
  }
}
