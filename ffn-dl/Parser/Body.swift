//
//  Body.swift
//  SwiftlyFFN
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import Foundation
import SwiftSoup

/// A Body HTML Component
/// HTML Tag: `<body>`
public final class Body: Component {
  internal init(body: Element) {
    super.init(elem: body)
  }
}
