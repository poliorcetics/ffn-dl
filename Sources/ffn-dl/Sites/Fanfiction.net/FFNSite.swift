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

  // MARK: - Finders

  // Author

  public static let authorFinder = Author.Finder(
    findURL: { doc in
      guard let link = doc.body?.selectFirst(withCSSQuery: #"a[href^="/u/"]"#) else {
        return nil
      }
      let urlString = link.attributeContent(withKey: "href")!
      return URL(string: "https://www.fanfiction.net\(urlString)")
    },
    findName: { doc in
      doc.body?.selectFirst(withCSSQuery: #"a[href^="/u/"]"#)?.ownText
    }
  )

  // Chapter

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

  public static let chapterFinder = Chapter.Finder(
    findURL: { doc in
      guard let head = doc.head else {
        return nil
      }
      return findCanonicalUrl(in: head)
    },
    findTitle: { doc in
      guard let body = doc.body else {
        return nil
      }
      let currentChapter = body.selectFirst(withCSSQuery: "option[selected]")

      return currentChapter?.ownText ?? (
        // Fallback title
        body.selectFirst(withCSSQuery: "b.xcontrast_txt")?.ownText ??
        // Second fallback title, because chapters with no title is possible on FFN.net
        ""
      )
    },
    findContent: { doc in
      let chapterContent = doc.body?.selectFirst(withCSSQuery: "div#storytext")
      return chapterContent?.html
    }
  )

  // Universe

  private static func findSingleLink(in doc: Document) -> Component? {
    doc.body?.selectFirst(withCSSQuery: "span.xcontrast_txt.icon-chevron-right.xicon-section-arrow+a")
  }

  private static func findCrossoverLink(in doc: Document) -> Component? {
    doc.body?.selectFirst(withCSSQuery: #"img[align="absmiddle"]+a"#)
  }

  public static let universeFinder = Universe.Finder(
    findURL: { doc in
      guard let link = findSingleLink(in: doc) ?? findCrossoverLink(in: doc) else {
          return nil
      }
      let urlString = link.attributeContent(withKey: "href")!
      return URL(string: "https://www.fanfiction.net\(urlString)")
    },
    findName: { doc in
      let link = findSingleLink(in: doc) ?? findCrossoverLink(in: doc)
      return link?.ownText
    },
    findCrossover: { doc in
      findCrossoverLink(in: doc) != nil
    }
  )
}
