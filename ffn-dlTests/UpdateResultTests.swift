//
//  UpdateResultTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  Copyright © 2019 Alexis Bourget. All rights reserved.
//

import XCTest
@testable import ffn_dl

final class UpdateResultTests: XCTestCase {
  func testIsFailureReturnsTrueWhenSelfIsFailure() {
    XCTAssertTrue(UpdateResult.failure("").isFailure)
  }

  func testIsFailureReturnsFalseWhenSelfIsNotFailure() {
    XCTAssertFalse(UpdateResult.success.isFailure)
    XCTAssertFalse(UpdateResult.unchanged.isFailure)
  }
}
