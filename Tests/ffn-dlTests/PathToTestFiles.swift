//
//  PathToTestFiles.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import Foundation

let pathToTestDir: String = {
  let urlToTestDir = URL(string: String(#file))!
    .deletingLastPathComponent()
    .appendingPathComponent("TestFiles")
  return urlToTestDir.absoluteString
}()
