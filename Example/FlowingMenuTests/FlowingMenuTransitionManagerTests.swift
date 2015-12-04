//
//  FlowingMenuTransitionManagerTests.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 04/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import XCTest

class FlowingMenuTransitionManagerTests: XCTTestCaseTemplate {
  func testAnimatingFlag() {
    let transitionManager = FlowingMenuTransitionManager()

    XCTAssertTrue(transitionManager.displayLink.paused)

    transitionManager.animating = true

    XCTAssertFalse(transitionManager.displayLink.paused)

    transitionManager.animating = false

    XCTAssertTrue(transitionManager.displayLink.paused)
  }
}
