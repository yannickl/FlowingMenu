//
//  FlowingMenuUIGestureRecognizerTests.swift
//  FlowingMenuTests
//
//  Created by Yannick LORIOT on 04/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import XCTest

class FlowingMenuUIGestureRecognizerTests: XCTTestCaseTemplate {
  var transitionManager = FlowingMenuTransitionManager()

  override func setUp() {
    super.setUp()

    transitionManager = FlowingMenuTransitionManager()
  }

  func testCurrentPath() {
    let defaultPath = transitionManager.currentPath()

    XCTAssertFalse(CGPathIsEmpty(defaultPath))
    XCTAssertEqual(CGPathGetPathBoundingBox(defaultPath), CGRectZero)

    transitionManager.controlViews[1].center = CGPointMake(5, 5)
    transitionManager.controlViews[2].center = CGPointMake(5, 5)
    transitionManager.controlViews[3].center = CGPointMake(0, 5)

    let customPath = transitionManager.currentPath()
    XCTAssertEqual(CGPathGetPathBoundingBox(customPath), CGRectMake(0, 0, 5, 5))
  }

  func testCurrentPath_Animating() {
    transitionManager.animating = true

    let defaultPath = transitionManager.currentPath()

    XCTAssertFalse(CGPathIsEmpty(defaultPath))
    XCTAssertEqual(CGPathGetPathBoundingBox(defaultPath), CGRectZero)

    transitionManager.controlViews[1].center = CGPointMake(5, 5)
    transitionManager.controlViews[2].center = CGPointMake(5, 5)
    transitionManager.controlViews[3].center = CGPointMake(0, 5)

    let customPath = transitionManager.currentPath()
    XCTAssertEqual(CGPathGetPathBoundingBox(customPath), CGRectMake(0, 0, 5, 5))
  }

  func testUpdateShapeLayer() {
    transitionManager.updateShapeLayer()

    XCTAssertFalse(CGPathIsEmpty(transitionManager.shapeLayer.path))
    XCTAssertEqual(CGPathGetPathBoundingBox(transitionManager.shapeLayer.path), CGRectZero)

    transitionManager.controlViews[1].center = CGPointMake(5, 5)
    transitionManager.controlViews[2].center = CGPointMake(5, 5)
    transitionManager.controlViews[3].center = CGPointMake(0, 5)

    transitionManager.updateShapeLayer()
    XCTAssertEqual(CGPathGetPathBoundingBox(transitionManager.shapeLayer.path), CGRectMake(0, 0, 5, 5))
  }

  // MARK: - Test Control Views

  func testMoveControlViewsToPoint_Default() {
    transitionManager.moveControlViewsToPoint(CGPointZero, waveWidth: 0)

    for view in transitionManager.controlViews {
      XCTAssertEqual(view.center, CGPointZero)
    }
  }

  func testMoveControlViewsToPoint_InitializedBefore() {
    for view in transitionManager.controlViews {
      view.center = CGPoint(x: 50, y: 50)
    }

    transitionManager.moveControlViewsToPoint(CGPointZero, waveWidth: 0)

    XCTAssertNotEqual(transitionManager.controlViews[0].center, CGPoint(x: 0, y: 50))
    XCTAssertNotEqual(transitionManager.controlViews[1].center, CGPoint(x: 50, y: 50))
    XCTAssertNotEqual(transitionManager.controlViews[2].center, CGPoint(x: 50, y: 50))
    XCTAssertEqual(transitionManager.controlViews[3].center, CGPointZero)
    XCTAssertNotEqual(transitionManager.controlViews[4].center, CGPoint(x: 50, y: 50))
    XCTAssertNotEqual(transitionManager.controlViews[5].center, CGPoint(x: 50, y: 50))
    XCTAssertNotEqual(transitionManager.controlViews[6].center, CGPoint(x: 50, y: 50))
    XCTAssertEqual(transitionManager.controlViews[7].center, CGPoint(x: 50, y: 50))
  }
}
