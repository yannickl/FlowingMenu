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
  Called by the flowing menu transition manager when it needs to display the menu.

  - parameter flowingfMenu: The flowingfMenu menu transition manager requesting
  the width.
  - parameter menuView: The menu view which will be displayed.
  - returns: The width of the menu view.
  */
  func flowingMenu(flowingfMenu: FlowingMenuTransitionManager, widthOfMenuView menuView: UIView) -> CGFloat

  // MARK: -
  func flowingMenuInteractiveTransitionWillPresent(flowingMenu: FlowingMenuTransitionManager)
  func flowingMenuInteractiveTransitionWillDismiss(flowingMenu: FlowingMenuTransitionManager)
}

extension FlowingMenuDelegate {
  public func flowingMenu(flowingfMenu: FlowingMenuTransitionManager, widthOfMenuView menuView: UIView) -> CGFloat {
    return menuView.bounds.width
  }
}