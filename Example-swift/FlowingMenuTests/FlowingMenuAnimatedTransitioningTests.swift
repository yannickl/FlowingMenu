//
//  FlowingMenuAnimatedTransitioningTests.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 04/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import XCTest

class FlowingMenuAnimatedTransitioningTests: XCTTestCaseTemplate {
  var transitionManager = FlowingMenuTransitionManager()

  override func setUp() {
    super.setUp()

    transitionManager = FlowingMenuTransitionManager()
  }

  func testTransitionDuration() {
    XCTAssertFalse(transitionManager.interactive)

    var duration = transitionManager.transitionDuration(using: nil)

    XCTAssertEqual(duration, 0.2)

    transitionManager.interactive = true

    duration = transitionManager.transitionDuration(using: nil)

    XCTAssertEqual(duration, 0.6)
  }
}
