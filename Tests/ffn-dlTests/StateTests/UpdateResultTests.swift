//
//  UpdateResultTests.swift
//  ffn-dlTests
//
//  Created by Alexis Bourget on 2019-12-31.
//  See LICENSE at the root of the project.
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
