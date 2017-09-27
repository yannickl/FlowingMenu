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

    let animation = transitionManager.animationController(forPresented: presented, presenting: presenting, source: source)

    XCTAssertNotNil(animation)
    XCTAssertEqual(transitionManager.animationMode, FlowingMenuTransitionManager.AnimationMode.presentation)
  }

  func testAnimationControllerForDismissedController() {
    let dismissed = UIViewController()

    let animation = transitionManager.animationController(forDismissed: dismissed)

    XCTAssertNotNil(animation)
    XCTAssertEqual(transitionManager.animationMode, FlowingMenuTransitionManager.AnimationMode.dismissal)
  }

  func testInteractionControllerForPresentation() {
    XCTAssertFalse(transitionManager.interactive)

    var interaction = transitionManager.interactionControllerForPresentation(using: transitionManager)

    XCTAssertNil(interaction)

    transitionManager.interactive = true

    interaction = transitionManager.interactionControllerForPresentation(using: transitionManager)

    XCTAssertNotNil(interaction)
  }

  func testInteractionControllerForDismissal() {
    XCTAssertFalse(transitionManager.interactive)

    var interaction = transitionManager.interactionControllerForDismissal(using: transitionManager)

    XCTAssertNil(interaction)

    transitionManager.interactive = true

    interaction = transitionManager.interactionControllerForDismissal(using: transitionManager)

    XCTAssertNotNil(interaction)
  }
}
