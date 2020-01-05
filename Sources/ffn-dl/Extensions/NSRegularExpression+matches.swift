//
//  NSRegularExpression+matches.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2020-01-03.
//  See LICENSE at the root of the project.
//

import Foundation

extension NSRegularExpression {
  /// Attempts to build a regular expression from the given pattern, else raises a `preconditionFailure(_:file:line:)`.
  /// - Parameter pattern: The regex patterns to use.
  convenience init(_ pattern: String) {
    do {
      try self.init(pattern: pattern)
    } catch {
      preconditionFailure("Illegal regular expression: \(pattern).")
    }
  }

  /// Returns `true` if the combination of `string` and `options` matches the registered pattern.
  /// - Parameters:
  ///   - string: the string to check.
  ///   - options: the options to use when checking.
  func matches(_ string: String, options: NSRegularExpression.MatchingOptions = []) -> Bool {
    let range = NSRange(location: 0, length: string.utf16.count)
    return firstMatch(in: string, options: options, range: range) != nil
  }
}
