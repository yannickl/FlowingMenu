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
 Conforming to the `UIViewControllerTransitioningDelegate` protocol to define the
 objects used to manage a fixed-length or interactive transition between view
 controllers.
*/
extension FlowingMenuTransitionManager: UIViewControllerTransitioningDelegate {
  /**
   Asks the flowing menu transition manager for the transition animator object to
   use when presenting a view controller.
   
   It returns itself.
  */
  public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    animationMode = .Presentation

    return self
  }

  /**
   Asks the flowing menu transition manager for the transition animator object to
   use when dismissing a view controller.
   
   It returns itself.
   */
  public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    animationMode = .Dismissal

    return self
  }

  /**
   Asks the flowing menu transition manager for the interactive animator object to
   use when presenting a view controller.
  */
  public func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    animationMode = .Presentation

    return interactive ? self : nil
  }

  /**
   Asks the flowing menu transition manager for the interactive animator object to
   use when dismissing a view controller.
  */
  public func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    animationMode = .Dismissal

    return interactive ? self : nil
  }
}