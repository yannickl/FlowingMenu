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
    let view  = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
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
    let expec = expectation(description: "Get Width")
    let view  = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 400))

    class ConcreteDelegate: FlowingMenuDelegate {
      let expectation: XCTestExpectation

      init(expectation: XCTestExpectation) {
        self.expectation = expectation
      }

      func flowingMenu(_ flowingMenu: FlowingMenuTransitionManager, widthOfMenuView menuView: UIView) -> CGFloat {
        expectation.fulfill()

        return menuView.bounds.width
      }
    }

    let delegate = ConcreteDelegate(expectation: expec)
    let width    = delegate.flowingMenu(transitionManager, widthOfMenuView: view)

    XCTAssertEqual(view.bounds.width, width)

    waitForExpectations(timeout: 0.1, handler: nil)
  }

  func testColorOfElasticShapeInFlowingMenu_Custom() {
    let expec = expectation(description: "Get Color")

    class ConcreteDelegate: FlowingMenuDelegate {
      let expectation: XCTestExpectation

      init(expectation: XCTestExpectation) {
        self.expectation = expectation
      }

      func colorOfElasticShapeInFlowingMenu(_ flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
        expectation.fulfill()

        return UIColor.yellow
      }
    }

    let delegate = ConcreteDelegate(expectation: expec)
    let color    = delegate.colorOfElasticShapeInFlowingMenu(transitionManager)

    XCTAssertEqual(color, UIColor.yellow)

    waitForExpectations(timeout: 0.1, handler: nil)
  }

  func testFlowingMenuNeedsPresentMenu_Custom() {
    let expec = expectation(description: "Present Menu")

    class ConcreteDelegate: FlowingMenuDelegate {
      let expectation: XCTestExpectation

      init(expectation: XCTestExpectation) {
        self.expectation = expectation
      }

      func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        expectation.fulfill()
      }
    }

    let delegate = ConcreteDelegate(expectation: expec)
    delegate.flowingMenuNeedsPresentMenu(transitionManager)

    waitForExpectations(timeout: 0.1, handler: nil)
  }

  func testFlowingMenuNeedsDismissMenu_Custom() {
    let expec = expectation(description: "Dismiss Menu")

    class ConcreteDelegate: FlowingMenuDelegate {
      let expectation: XCTestExpectation

      init(expectation: XCTestExpectation) {
        self.expectation = expectation
      }

      func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
        expectation.fulfill()
      }
    }

    let delegate = ConcreteDelegate(expectation: expec)
    delegate.flowingMenuNeedsDismissMenu(transitionManager)

    waitForExpectations(timeout: 0.1, handler: nil)
  }
}
