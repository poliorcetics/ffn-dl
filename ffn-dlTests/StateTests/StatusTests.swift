//
//  StatusTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
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
