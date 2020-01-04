//
//  Head.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
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
