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
    XCTAssertTrue(transitionManager.displayLink.isPaused)

    transitionManager.animating = true

    XCTAssertFalse(transitionManager.displayLink.isPaused)

    transitionManager.animating = false

    XCTAssertTrue(transitionManager.displayLink.isPaused)
  }

  func testPresentMenu() {
    let expec = expectation(description: "Present menu animation")

    DispatchQueue.main.async { [weak self] in
      let menuView      = UIView()
      let otherView     = UIView()
      let containerView = UIView()
      let status        = FlowingMenuTransitionStatus(cancelled: false)
      let duration      = 0.2

      self?.transitionManager.presentMenu(menuView, otherView: otherView, containerView: containerView, status: status, duration: duration) {
        expec.fulfill()
      }
    }

    waitForExpectations(timeout: 1, handler: nil)
  }

  func testPresentMenu_Interactive() {
    let expec = expectation(description: "Present menu animation")

    DispatchQueue.main.async { [weak self] in
      let menuView      = UIView()
      let otherView     = UIView()
      let containerView = UIView()
      let status        = FlowingMenuTransitionStatus(cancelled: false)
      let duration      = 0.2

      self?.transitionManager.interactive = true
      self?.transitionManager.presentMenu(menuView, otherView: otherView, containerView: containerView, status: status, duration: duration) {
        expec.fulfill()
      }
    }

    waitForExpectations(timeout: 1, handler: nil)
  }

  func testDismissMenu() {
    let expec = expectation(description: "Dismiss menu animation")

    DispatchQueue.main.async { [weak self] in
      let menuView      = UIView()
      let otherView     = UIView()
      let containerView = UIView()
      let status        = FlowingMenuTransitionStatus(cancelled: false)
      let duration      = 0.2

      self?.transitionManager.dismissMenu(menuView, otherView: otherView, containerView: containerView, status: status, duration: duration) {
        expec.fulfill()
      }
    }

    waitForExpectations(timeout: 1, handler: nil)
  }

  func testDismissMenu_Interactive() {
    let expec = expectation(description: "Dismiss menu animation")

    DispatchQueue.main.async { [weak self] in
      let menuView      = UIView()
      let otherView     = UIView()
      let containerView = UIView()
      let status        = FlowingMenuTransitionStatus(cancelled: false)
      let duration      = 0.2

      self?.transitionManager.interactive = true
      self?.transitionManager.dismissMenu(menuView, otherView: otherView, containerView: containerView, status: status, duration: duration) {
        expec.fulfill()
      }
    }

    waitForExpectations(timeout: 1, handler: nil)
  }
}
