//
//  PathToTestFiles.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import Foundation

let pathToTestDir: String = {
  let urlToTestDir = URL(string: String(#file))!
    .deletingLastPathComponent()
    .appendingPathComponent("TestFiles")
  return urlToTestDir.absoluteString
}()
