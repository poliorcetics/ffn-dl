//
//  FFNSite.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2020-01-03.
//  See LICENSE at the root of the project.
//

import Foundation

internal struct FFNSite {
  /// Name of the site
  static let name = "Fanfiction.net"
  /// Main URL, the one used when the webbrowser is a computer one.
  static let mainURL = URL(string: "https://www.fanfiction.net")!
  /// Mobile URL, the one used when the webbrowser is a mobile one.
  static let mobileURL = URL(string: "https://m.fanfiction.net")!

  /// Regex matching the site URL, in its `mainURL` **and** `mobileURL` forms.
  static let siteRegex = NSRegularExpression("https://(m|www).fanfiction.net(/.*)?")

  static var mainURLString: String {
    mainURL.absoluteString
  }

  static var mobileURLString: String {
    mobileURL.absoluteString
  }

  /// Attempts to convert the given URL to the format of `mainURL`
  static func convertToMainURL(from url: URL) -> URL? {
    guard siteRegex.matches(url.absoluteString) else {
      return nil
    }
    let newURLString = url
      .absoluteString
      .replacingOccurrences(of: "://m", with: "://www")
    return URL(string: newURLString)
  }

  /// Attempts to find the canonical URL in the following format:
  /// https://(m|www).fanfiction.net/s/`id`/`chapter`/`text-name`
  static func findCanonicalUrl(in head: Head) -> URL? {
    let query = #"link[rel="canonical"]"#
    guard let link = head.select(withCSSQuery: query).first,
          let canonicalHref = link.attributeContent(withKey: "href")
    else {
      return nil
    }
    return URL(string: "https:\(canonicalHref)")
  }
}
