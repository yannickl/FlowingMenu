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
 The `FlowingMenuTransitionManager` aims to drive the transition between two
 views by providing an flowing/elastic and bouncing animation effect.
 
 You must adopt the `FlowingMenuDelegate` if you want to make the transition
 interactive. It relies on the `UIPercentDrivenInteractiveTransition` and the 
 manager needs some informations to know which view displayed.
*/
public final class FlowingMenuTransitionManager: UIPercentDrivenInteractiveTransition {
  enum AnimationMode {
    case Presentation
    case Dismissal
  }

  public weak var delegate: FlowingMenuDelegate?

  var menuWidth     = CGFloat(250)
  var animationMode = AnimationMode.Presentation
  var interactive   = false

  func presentMenu(menuView: UIView, otherView: UIView, containerView: UIView, duration: NSTimeInterval, completion: () -> Void) {
    // Composing the view
    let ov = otherView.snapshotViewAfterScreenUpdates(true)

    containerView.addSubview(ov)
    containerView.addSubview(menuView)

    // Add a mask to the menu to create the bubble effect
    let maskLayer       = CAShapeLayer()
    menuView.layer.mask = maskLayer

    let maxSideSize = max(menuView.bounds.width, menuView.bounds.height)
    let beginRect   = CGRectMake(1, menuView.bounds.height / 2 - 1, 2, 2)
    let middleRect  = CGRectMake(-menuWidth, 0, menuWidth * 2, menuView.bounds.height)
    let endRect     = CGRectMake(-maxSideSize, menuView.bounds.height / 2 - maxSideSize, maxSideSize * 2, maxSideSize * 2)

    // Defining the menu frame
    var menuFrame        = menuView.frame
    menuFrame.size.width = menuWidth
    menuView.frame       = menuFrame

    // Start the animations
    let bubbleAnim                 = CAKeyframeAnimation(keyPath: "path")
    bubbleAnim.values              = [beginRect, middleRect, endRect].map { UIBezierPath(ovalInRect: $0).CGPath }
    bubbleAnim.keyTimes            = [0, 0.4, 1]
    bubbleAnim.duration            = duration
    bubbleAnim.removedOnCompletion = false
    bubbleAnim.fillMode            = kCAFillModeForwards
    maskLayer.addAnimation(bubbleAnim, forKey: "bubbleAnim")

    UIView.animateWithDuration(duration, animations: { _ in
      menuFrame.origin.x = 0
      menuView.frame     = menuFrame
      otherView.alpha    = 0
      ov.alpha           = 0.4
      }) { _ in
        maskLayer.removeAllAnimations()
        menuView.layer.mask = nil

        completion()
    }
  }

  func dismissMenu(menuView: UIView, otherView: UIView, containerView: UIView, duration: NSTimeInterval, completion: () -> Void) {
    let ov = otherView.snapshotViewAfterScreenUpdates(true)

    var menuFrame = menuView.frame

    containerView.addSubview(otherView)
    containerView.addSubview(ov)
    containerView.addSubview(menuView)

    otherView.alpha = 0
    ov.alpha        = 0.4

    UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseOut], animations: { () -> Void in
      menuFrame.origin.x = -menuFrame.width
      menuView.frame     = menuFrame

      otherView.alpha = 1
      ov.alpha        = 1
      }) { _ in
        completion()
    }
  }
}