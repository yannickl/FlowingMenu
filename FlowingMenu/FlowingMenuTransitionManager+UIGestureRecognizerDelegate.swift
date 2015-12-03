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

extension FlowingMenuTransitionManager {
  public func setInteractivePresentationView(view: UIView) {
    let screenEdgePanGesture   = UIScreenEdgePanGestureRecognizer()
    screenEdgePanGesture.edges = .Left
    screenEdgePanGesture.addTarget(self, action:"panToPresentAction:")

    view.addGestureRecognizer(screenEdgePanGesture)
  }

  public func setInteractiveDismissView(view: UIView) {
    let panGesture                    = UIPanGestureRecognizer()
    panGesture.maximumNumberOfTouches = 1
    panGesture.addTarget(self, action:"panToDismissAction:")

    view.addGestureRecognizer(panGesture)
  }

  func panToPresentAction(pan: UIScreenEdgePanGestureRecognizer) {
    let view        = pan.view!
    let translation = pan.translationInView(view)

    let percentage = min(max(translation.x / menuWidth, 0), 1)

    switch pan.state {
    case .Began:
      interactive = true

      delegate?.flowingMenuInteractiveTransitionWillPresent(self)
    case .Changed:
      updateInteractiveTransition(percentage)
    default: // .Ended, .Cancelled, .Failed ...
      interactive = false

      if percentage >= 0.3 {
        finishInteractiveTransition()
      }
      else {
        cancelInteractiveTransition()
      }
    }
  }

  func panToDismissAction(pan: UIPanGestureRecognizer) {
    let view        = pan.view!
    let translation = pan.translationInView(view)

    let percentage = min(max(translation.x / menuWidth * -1, 0), 1)

    switch pan.state {
    case .Began:
      interactive = true

      delegate?.flowingMenuInteractiveTransitionWillDismiss(self)
    case .Changed:
      updateInteractiveTransition(percentage)
    default: // .Ended, .Cancelled, .Failed ...
      interactive = false

      if percentage >= 0.3 {
        finishInteractiveTransition()
      }
      else {
        cancelInteractiveTransition()
      }
    }
  }
}
