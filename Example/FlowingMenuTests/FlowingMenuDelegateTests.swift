//
//  FlowingMenuDelegateTests.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 04/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import XCTest

class FlowingMenuDelegateTests: XCTTestCaseTemplate {
  var transitionManager = FlowingMenuTransitionManager()

  override func setUp() {
    super.setUp()

    transitionManager = FlowingMenuTransitionManager()
  }

  func testFlowingMenuTransitionManagerWidthOfMenuView_Default() {
    let view  = UIView(frame: CGRectMake(0, 0, 36, 36))
    let width = transitionManager.flowingMenuTransitionManager(transitionManager, widthOfMenuView: view)

    XCTAssertEqual(width, 24)
  }

  func testColorOfElasticShapeInFlowingMenuTransitionManager_Default() {
    let defaultColor = transitionManager.colorOfElasticShapeInFlowingMenuTransitionManager(transitionManager)

    XCTAssertNil(defaultColor)
  }

  func testFlowingMenuTransitionManagerNeedsPresentMenu_Default() {
    transitionManager.flowingMenuTransitionManagerNeedsPresentMenu(transitionManager)
  }

  func testFlowingMenuTransitionManagerNeedsDismissMenu_Default() {
    transitionManager.flowingMenuTransitionManagerNeedsDismissMenu(transitionManager)
  }
}