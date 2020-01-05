//
//  Site.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2020-01-05.
//  See LICENSE at the root of the project.
//

import Foundation

/// Represents a website that contains fanfictions.
public protocol Site {
  /// Name of the site.
  static var name: String { get }
  /// Main URL, the one used when the webbrowser is a computer one.
  static var mainURL: URL { get }
  /// Mobile URL, the one used when the webbrowser is a mobile one.
  ///
  /// Default implementation: `mainURL`.
  static var mobileURL: URL { get }

  /// Regex matching the site URL, in its `mainURL` **and** `mobileURL` forms.
  static var regex: NSRegularExpression { get }

  /// Attempts to convert the given `url` to use the base URL of the main site.
  ///
  /// Default implementation provided.
  static func convertToMainURL(_ url: URL) -> URL?
}

public extension Site {
  // MARK: Default implementations

  static var mobileURL: URL {
    mainURL
  }

  static func convertToMainURL(_ url: URL) -> URL? {
    guard regex.matches(url.absoluteString) else {
      return nil
    }
    let newURLString = url
      .absoluteString
      .replacingOccurrences(of: mobileAbsoluteString, with: mainAbsoluteString)
    return URL(string: newURLString)
  }
}

public extension Site {
  // MARK: Added computed variables

  /// Absolute string of the `mainURL`.
  static var mainAbsoluteString: String {
    mainURL.absoluteString
  }

  /// Absolute string of the `mobileURL`.
  static var mobileAbsoluteString: String {
    mobileURL.absoluteString
  }

  /// Short description of the site.
  static var description: String {
    "\(name) - \(mainAbsoluteString)"
  }
}
