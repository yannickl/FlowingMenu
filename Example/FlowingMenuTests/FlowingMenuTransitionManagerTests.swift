//
//  FlowingMenuTransitionManagerTests.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 04/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import XCTest

class FlowingMenuTransitionManagerTests: XCTTestCaseTemplate {
  var transitionManager = FlowingMenuTransitionManager()

  override func setUp() {
    super.setUp()

    transitionManager = FlowingMenuTransitionManager()
  }

  func testAnimatingFlag() {
    XCTAssertTrue(transitionManager.displayLink.paused)

    transitionManager.animating = true

    XCTAssertFalse(transitionManager.displayLink.paused)

    transitionManager.animating = false

    XCTAssertTrue(transitionManager.displayLink.paused)
  }

  func testPresentMenu() {
    let expectation = expectationWithDescription("Present menu animation")

    dispatch_async(dispatch_get_main_queue()) { [weak self] in
      let menuView      = UIView()
      let otherView     = UIView()
      let containerView = UIView()
      let status        = FlowingMenuTransitionStatus(cancelled: false)
      let duration      = 0.2

      self?.transitionManager.presentMenu(menuView, otherView: otherView, containerView: containerView, status: status, duration: duration) {
        expectation.fulfill()
      }
    }

    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testPresentMenu_Interactive() {
    let expectation = expectationWithDescription("Present menu animation")

    dispatch_async(dispatch_get_main_queue()) { [weak self] in
      let menuView      = UIView()
      let otherView     = UIView()
      let containerView = UIView()
      let status        = FlowingMenuTransitionStatus(cancelled: false)
      let duration      = 0.2

      self?.transitionManager.interactive = true
      self?.transitionManager.presentMenu(menuView, otherView: otherView, containerView: containerView, status: status, duration: duration) {
        expectation.fulfill()
      }
    }

    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testDismissMenu() {
    let expectation = expectationWithDescription("Present menu animation")

    dispatch_async(dispatch_get_main_queue()) { [weak self] in
      let menuView      = UIView()
      let otherView     = UIView()
      let containerView = UIView()
      let status        = FlowingMenuTransitionStatus(cancelled: false)
      let duration      = 0.2

      self?.transitionManager.dismissMenu(menuView, otherView: otherView, containerView: containerView, status: status, duration: duration) {
        expectation.fulfill()
      }
    }

    waitForExpectationsWithTimeout(1, handler: nil)
  }

  func testDismissMenu_Interactive() {
    let expectation = expectationWithDescription("Present menu animation")

    dispatch_async(dispatch_get_main_queue()) { [weak self] in
      let menuView      = UIView()
      let otherView     = UIView()
      let containerView = UIView()
      let status        = FlowingMenuTransitionStatus(cancelled: false)
      let duration      = 0.2

      self?.transitionManager.interactive = true
      self?.transitionManager.dismissMenu(menuView, otherView: otherView, containerView: containerView, status: status, duration: duration) {
        expectation.fulfill()
      }
    }

    waitForExpectationsWithTimeout(1, handler: nil)
  }
}
