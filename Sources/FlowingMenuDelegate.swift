/*
 * FlowingMenu
 *
 * Copyright 2015-present Yannick Loriot.
 * http://yannickloriot.com
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

import UIKit

/**
 The delegate of a `FlowMenuTransitionManager` object should adopt this protocol
 and implement to manage the .
 */
public protocol FlowingMenuDelegate: class {
  // MARK: - Laying Out the Menu

  /**
  Called by the flowing menu transition manager when it needs to display the
  menu.

  - parameter flowingMenu: The flowing menu transition manager requesting the
  width.
  - parameter menuView: The menu view which will be displayed.
  - returns: The width of the menu view. Outside the menu view a black overlay 
  will be displayed.
  */
  func flowingMenu(flowingMenu: FlowingMenuTransitionManager, widthOfMenuView menuView: UIView) -> CGFloat

  // MARK: - Drawing the Elastic Shape

  /**
  Asks the delegate the color of the shape drawn during an interactive
  transition.

  - parameter flowingMenu: The flowing menu transition manager requesting the
  color.
  - returns: The shape color. If nil it will use the menu background color and
  if menu has no background color, the shape will be black.
  */
  func colorOfElasticShapeInFlowingMenu(flowingMenu: FlowingMenuTransitionManager) -> UIColor?

  // MARK: - Responding to Interactive Transition

  /**
  Called by the flowing menu transition manager when the interactive transition
  begins its presentation. You should implement this methods to present your
  menu view.
  
  - parameter flowingMenu: The flowing menu transition manager which needs
  present the menu.
  */
  func flowingMenuNeedsPresentMenu(flowingMenu: FlowingMenuTransitionManager)

  /**
   Called by the flowing menu transition manager when the interactive transition
   begins its dismissal. You should implement this methods to dismiss your menu
   view.

   - parameter flowingMenu: The flowing menu transition manager which needs
   dismiss the menu.
   */
  func flowingMenuNeedsDismissMenu(flowingMenu: FlowingMenuTransitionManager)
}

extension FlowingMenuDelegate {
  /// Returns the 2/3 menu view width.
  public func flowingMenu(flowingMenu: FlowingMenuTransitionManager, widthOfMenuView menuView: UIView) -> CGFloat {
    return menuView.bounds.width * 2 / 3
  }

  /// Use the menu background by default.
  public func colorOfElasticShapeInFlowingMenu(flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
    return nil
  }

  /// You should implement this method to display the menu. By default nothing happens.
  public func flowingMenuNeedsPresentMenu(flowingMenu: FlowingMenuTransitionManager) {
  }

  /// You should implement this method to dismiss the menu. By default nothing happens.
  public func flowingMenuNeedsDismissMenu(flowingMenu: FlowingMenuTransitionManager) {
  }
}