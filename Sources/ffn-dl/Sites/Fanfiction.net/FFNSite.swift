//
//  FFNSite.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2020-01-03.
//  See LICENSE at the root of the project.
//

import Foundation

public enum FFNSite: Site {
  public static let name = "Fanfiction.net"
  public static let mainURL = URL(string: "https://www.fanfiction.net")!
  public static let mobileURL = URL(string: "https://m.fanfiction.net")!

  public static let regex = NSRegularExpression("https://(m|www).fanfiction.net(/.*)?")

  /// Attempts to find the canonical URL in the following format:
  /// https://(m|www).fanfiction.net/s/`id`/`chapter`/`text-name`
  internal static func findCanonicalUrl(in head: Head) -> URL? {
    let query = #"link[rel="canonical"]"#
    guard let link = head.select(withCSSQuery: query).first,
          let canonicalHref = link.attributeContent(withKey: "href")
    else {
      return nil
    }
    return URL(string: "https:\(canonicalHref)")
  }
}
