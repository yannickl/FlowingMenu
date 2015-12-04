//
//  FlowingMenuTransitioningDelegateTests.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 04/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import XCTest

class FlowingMenuTransitioningDelegateTests: XCTTestCaseTemplate {
  var transitionManager = FlowingMenuTransitionManager()

  override func setUp() {
    super.setUp()

    transitionManager = FlowingMenuTransitionManager()
  }

  func testAnimationControllerForPresentedController() {
    let presented  = UIViewController()
    let presenting = UIViewController()
    let source     = UIViewController()

    let animation = transitionManager.animationControllerForPresentedController(presented, presentingController: presenting, sourceController: source)

    XCTAssertNotNil(animation)
    XCTAssertEqual(transitionManager.animationMode, FlowingMenuTransitionManager.AnimationMode.Presentation)
  }

  func testAnimationControllerForDismissedController() {
    let dismissed = UIViewController()

    let animation = transitionManager.animationControllerForDismissedController(dismissed)

    XCTAssertNotNil(animation)
    XCTAssertEqual(transitionManager.animationMode, FlowingMenuTransitionManager.AnimationMode.Dismissal)
  }

  func testInteractionControllerForPresentation() {
    XCTAssertFalse(transitionManager.interactive)

    var interaction = transitionManager.interactionControllerForPresentation(transitionManager)

    XCTAssertNil(interaction)

    transitionManager.interactive = true

    interaction = transitionManager.interactionControllerForPresentation(transitionManager)

    XCTAssertNotNil(interaction)
  }

  func testInteractionControllerForDismissal() {
    XCTAssertFalse(transitionManager.interactive)

    var interaction = transitionManager.interactionControllerForDismissal(transitionManager)

    XCTAssertNil(interaction)

    transitionManager.interactive = true

    interaction = transitionManager.interactionControllerForDismissal(transitionManager)

    XCTAssertNotNil(interaction)
  }
}