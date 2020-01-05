//
//  StatusTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
//

import XCTest
@testable import ffn_dl

final class StatusTests: XCTestCase {
  func testStatusDescription() {
    Status.allCases.forEach {
      XCTAssertEqual("\($0)", $0.rawValue)
    }
  }
}
