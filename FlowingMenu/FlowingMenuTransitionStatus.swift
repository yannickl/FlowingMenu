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
 The FlowingMenuTransitionStatus object aims to make the transition manager
 testable by providing a concevient way to access the
 `UIViewControllerContextTransitioning` `transitionWasCancelled` method.
*/
final class FlowingMenuTransitionStatus {
  private let cancelled: Bool
  private let context: UIViewControllerContextTransitioning?

  // MARK: - Initializing a TransitionStatus Object

  /// Initializer for testing purpose.
  init(cancelled: Bool) {
    self.context   = nil
    self.cancelled = cancelled
  }

  /// Initializer for running purpose.
  init(context: UIViewControllerContextTransitioning? = nil) {
    self.context      = context
    self.cancelled = false
  }

  // MARK: - Reporting the Transition Progress

  /**
   Returns a Boolean value indicating whether the transition was canceled.

   true if the transition was canceled or false if it is ongoing or finished
   normally.

  - returns: true if the transition was canceled or NO if it is ongoing or
   finished normally.
  */
  func transitionWasCancelled() -> Bool {
    return context?.transitionWasCancelled() ?? cancelled
  }
}