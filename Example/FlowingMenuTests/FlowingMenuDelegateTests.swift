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

  // MARK: - Default

  func testFlowingMenuWidthOfMenuView_Default() {
    let view  = UIView(frame: CGRectMake(0, 0, 36, 36))
    let width = transitionManager.flowingMenu(transitionManager, widthOfMenuView: view)

    XCTAssertEqual(width, 24)
  }

  func testColorOfElasticShapeInFlowingMenu_Default() {
    let defaultColor = transitionManager.colorOfElasticShapeInFlowingMenu(transitionManager)

    XCTAssertNil(defaultColor)
  }

  func testFlowingMenuNeedsPresentMenu_Default() {
    transitionManager.flowingMenuNeedsPresentMenu(transitionManager)
  }

  func testFlowingMenuNeedsDismissMenu_Default() {
    transitionManager.flowingMenuNeedsDismissMenu(transitionManager)
  }

  // MARK: - Custom

  func testFlowingMenuWidthOfMenuView_Custom() {
    let expectation = expectationWithDescription("Get Width")
    let view        = UIView(frame: CGRectMake(0, 0, 300, 400))

    class ConcreteDelegate: FlowingMenuDelegate {
      let expectation: XCTestExpectation

      init(expectation: XCTestExpectation) {
        self.expectation = expectation
      }

      private func flowingMenu(flowingMenu: FlowingMenuTransitionManager, widthOfMenuView menuView: UIView) -> CGFloat {
        expectation.fulfill()

        return menuView.bounds.width
      }
    }

    let delegate = ConcreteDelegate(expectation: expectation)
    let width    = delegate.flowingMenu(transitionManager, widthOfMenuView: view)

    XCTAssertEqual(view.bounds.width, width)

    waitForExpectationsWithTimeout(0.1, handler: nil)
  }

  func testColorOfElasticShapeInFlowingMenu_Custom() {
    let expectation = expectationWithDescription("Get Color")

    class ConcreteDelegate: FlowingMenuDelegate {
      let expectation: XCTestExpectation

      init(expectation: XCTestExpectation) {
        self.expectation = expectation
      }

      private func colorOfElasticShapeInFlowingMenu(flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
        expectation.fulfill()

        return UIColor.yellowColor()
      }
    }

    let delegate = ConcreteDelegate(expectation: expectation)
    let color    = delegate.colorOfElasticShapeInFlowingMenu(transitionManager)

    XCTAssertEqual(color, UIColor.yellowColor())

    waitForExpectationsWithTimeout(0.1, handler: nil)
  }

  func testFlowingMenuNeedsPresentMenu_Custom() {
    let expectation = expectationWithDescription("Present Menu")

    class ConcreteDelegate: FlowingMenuDelegate {
      let expectation: XCTestExpectation

      init(expectation: XCTestExpectation) {
        self.expectation = expectation
      }

      private func flowingMenuNeedsPresentMenu(flowingMenu: FlowingMenuTransitionManager) {
        expectation.fulfill()
      }
    }

    let delegate = ConcreteDelegate(expectation: expectation)
    delegate.flowingMenuNeedsPresentMenu(transitionManager)

    waitForExpectationsWithTimeout(0.1, handler: nil)
  }

  func testFlowingMenuNeedsDismissMenu_Custom() {
    let expectation = expectationWithDescription("Dismiss Menu")

    class ConcreteDelegate: FlowingMenuDelegate {
      let expectation: XCTestExpectation

      init(expectation: XCTestExpectation) {
        self.expectation = expectation
      }

      private func flowingMenuNeedsDismissMenu(flowingMenu: FlowingMenuTransitionManager) {
        expectation.fulfill()
      }
    }

    let delegate = ConcreteDelegate(expectation: expectation)
    delegate.flowingMenuNeedsDismissMenu(transitionManager)

    waitForExpectationsWithTimeout(0.1, handler: nil)
  }
}