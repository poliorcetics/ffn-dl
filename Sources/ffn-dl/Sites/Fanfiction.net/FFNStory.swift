//
//  FFNStory.swift
//  ffn-dl
//
//  Created by Alexis Bourget on 2020-01-03.
//  See LICENSE at the root of the project.
//

import Foundation

public struct FFNStory: Story, Hashable {
  private static let _site = FFNSite.self
  public static let site: Site.Type = _site

  // MARK: - Stored Variables

  public let url: URL

  public private(set) var title: String
  public private(set) var summary: String
  public private(set) var chapters: [Chapter]

  public let author: Author
  public let universe: Universe

  public private(set) var tokens: String

  public init(url: URL, title: String, summary: String, chapters: [Chapter],
              author: Author, universe: Universe, tokens: String) {
    precondition(!chapters.isEmpty)

    self.url = url
    self.title = title
    self.summary = summary
    self.chapters = chapters
    self.author = author
    self.universe = universe
    self.tokens = tokens
  }
}

public extension FFNStory {
  // MARK: - Computed Variables

  var chapterCount: Int { findInt(in: tokens, searching: "Chapters:") ?? 1 }

  var wordCount: Int { findInt(in: tokens, searching: "Words:") ?? 0 }

  var language: String {
    let splitTokens = tokens.split(separator: "-")
    return splitTokens[1].replacingOccurrences(of: " ", with: "")
  }

  var status: Status {
    tokens.contains("- Status: Complete -") ? .complete : .inProgress
  }

  // MARK: - Finders

  // Author

  internal static let authorFinder = Author.Finder(
    findURL: { doc in
      guard let link = doc.body?.selectFirst(withCSSQuery: #"a[href^="/u/"]"#) else {
        return nil
      }
      let urlString = link.attributeContent(withKey: "href")!
      return URL(string: "https://www.fanfiction.net\(urlString)")
    },
    findName: { doc in doc.body?.selectFirst(withCSSQuery: #"a[href^="/u/"]"#)?.ownText }
  )

  // Chapter

  internal static let chapterFinder = Chapter.Finder(
    findURL: { doc in
      guard let head = doc.head else {
        return nil
      }
      return Self._site.findCanonicalUrl(in: head)
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

  internal static let universeFinder = Universe.Finder(
    findURL: { doc in
      guard let link = findSingleLink(in: doc) ?? findCrossoverLink(in: doc)
      else {
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

public extension FFNStory {
  // MARK: - Initializers

  init?(from doc: Document) {
    guard let head = doc.head,
      let url = Self._site.findCanonicalUrl(in: head)?.makeChapterURL(for: 1),
      let body = doc.body,
      let title = findTitle(in: body),
      let author = Author(from: doc, withFinder: Self.authorFinder),
      let summary = findSummary(in: body),
      let tokens = findTokens(in: body),
      let universe = Universe(from: doc, withFinder: Self.universeFinder)
      else {
        return nil
    }

    let chapCount = findInt(in: tokens, searching: "Chapters: ") ?? 1
    let chapters: [Chapter]

    // Here we're not sure if the chapter from which we got the informations
    // was the 1st, the 3rd or the last and so we get them all.
    // For small fics it's not optimal, since we download a chapter twice,
    // for longer fics the cost is amortised.
    if chapCount > 1 {
      chapters = (1...chapCount).compactMap { chapNum -> Chapter? in
        let chapUrl = url.makeChapterURL(for: chapNum)
        return Chapter(from: chapUrl, withFinder: Self.chapterFinder)
      }
    // In the case where there's only one chapter, we've already downloaded it
    } else {
      chapters = [Chapter(from: doc, withFinder: Self.chapterFinder)].compactMap { $0 }
    }

    guard chapters.count == chapCount else {
      return nil
    }

    self.init(url: url, title: title, summary: summary, chapters: chapters,
              author: author, universe: universe, tokens: tokens)
  }

  // MARK: - Update

  // TODO: Refactor this method
  mutating func update(chapters: [Int]) -> Story.UpdateResult {
    let updating = Set(chapters).sorted()

    if updating.isEmpty {
      return (.failure("No chapters to update"), [])
    }

    guard updating.first! > 0 else {
      return (.failure("\(updating.first!) is not a valid chapter"), [])
    }

    let old: Self
    var res: Story.UpdateResult = (.failure(""), [])

    defer {
      res.updatedChapters = Set(res.updatedChapters).sorted()
      if res.state.isFailure {
        self = old
      }
    }

    let maxChap = updating.max()! // Previous tests make this safe
    // Updating the existing chapters
    // We don't care if their update fails
    updating
      .filter { $0 <= self.chapters.count && $0 < maxChap }
      .forEach {
        if updateExisting(chapter: $0).state == .success {
          res.updatedChapters.append($0)
        }
    }
    // The updated existing chapters are kept
    old = self

    switch update(chapter: maxChap) {
    case (.failure(let msg), _):
      res.state = .failure(msg)
    case (.unchanged, _):
      res.state = .unchanged
    case (.success, let updatedChapters):
      res.updatedChapters.append(contentsOf: updatedChapters)
      res.state = .success
    }

    return res
  }

  // MARK: Update Helpers

  private mutating func update(chapter: Int) -> Story.UpdateResult {
    precondition(chapter > 0)

    var res = update(chapter: chapter, updatingInfos: true)

    let newChaptersAvailable = chapterCount != chapters.count
    if newChaptersAvailable && !res.state.isFailure {
      let partialRes = updateMissing()
      res.state = partialRes.state
      res.updatedChapters.append(contentsOf: partialRes.updatedChapters)
    }

    return res
  }

  private mutating func updateMissing() -> Story.UpdateResult {
    precondition(chapters.count < chapterCount)
    return updateIncluding(from: self.chapters.count + 1, upTo: chapterCount)
  }

  private mutating func update(chapter: Int, updatingInfos: Bool) -> Story.UpdateResult {
    precondition(chapter > 0)

    var res: Story.UpdateResult

    if chapter <= chapterCount {
      res = updateExisting(chapter: chapter)
    } else {
      res = updateNew(upTo: chapter)
    }

    if updatingInfos && !res.state.isFailure {
      res.state = updateInfos(with: chapter)
    }

    return res
  }

  private mutating func updateExisting(chapter: Int) -> Story.UpdateResult {
    precondition(chapter > 0 && chapter <= chapterCount)

    let chapterRes = chapters[chapter - 1].update()
    return (chapterRes, chapterRes == .success ? [chapter] : [])
  }

  private mutating func updateNew(upTo chapter: Int) -> Story.UpdateResult {
    precondition(chapter > chapterCount)
    return updateIncluding(from: self.chapters.count + 1, upTo: chapter)
  }

  private mutating func updateIncluding(from startChapter: Int, upTo endChapter: Int) -> Story.UpdateResult {
    let newChaptersIndices = Array(startChapter...endChapter)
    var newChapters: [Chapter] = []

    for chapNum in newChaptersIndices {
      let chapUrl = url.makeChapterURL(for: chapNum)
      if let newChapter = Chapter(from: chapUrl, withFinder: Self.chapterFinder) {
        newChapters.append(newChapter)
      } else {
        return (.failure("Failed to download all chapters up to \(endChapter) (failed on \(chapNum))"), [])
      }
    }

    chapters.append(contentsOf: newChapters)
    return (.success, newChaptersIndices)
  }

  private mutating func updateInfos(with chapter: Int) -> UpdateResult {
    let infosURL = url.makeChapterURL(for: chapter)

    guard let doc = infosURL.getDocument(),
          let body = doc.body,
          let title = findTitle(in: body),
          let summary = findSummary(in: body),
          let tokens = findTokens(in: body)
    else {
      return .failure("Failed to update informations")
    }

    // Testing the values from the most likely to have changed to the least likely
    let changed = self.tokens != tokens
      || self.summary != summary
      || self.title != title

    self.title = title
    self.summary = summary
    self.tokens = tokens

    return changed ? .success : .unchanged
  }
}

// MARK: - Helpers functions

fileprivate func findInt(in string: String, searching searched: String) -> Int? {
  let splitTokens = string.split(separator: "-")
  guard let wantedToken = splitTokens.first(where: { $0.contains(searched) }) else {
    return nil
  }
  let wanted = wantedToken
    .replacingOccurrences(of: searched, with: "")
    .replacingOccurrences(of: " ", with: "")
    .replacingOccurrences(of: ",", with: "")
  return Int(wanted)
}

fileprivate func findTitle(in body: Body) -> String? {
  body.selectFirst(withCSSQuery: "b.xcontrast_txt")?.ownText
}

fileprivate func findSummary(in body: Body) -> String? {
  body.selectFirst(withCSSQuery: #"div.xcontrast_txt[style="margin-top:2px"]"#)?.fullText
}

fileprivate func findTokens(in body: Body) -> String? {
  body.selectFirst(withCSSQuery: "span.xgray.xcontrast_txt")?.fullText
}

fileprivate extension URL {
  /// Makes a chapter URL from a basic FFN URL
  /// - Parameter chapter: the number of the chapter (`1...chapterCount`)
  func makeChapterURL(for chapterNum: Int) -> URL {
    precondition(chapterNum > 0)

    let storyID = pathComponents[2]
    return URL(string: "\(FFNStory.site.mainAbsoluteString)/s/\(storyID)/\(chapterNum)")!
  }
}
