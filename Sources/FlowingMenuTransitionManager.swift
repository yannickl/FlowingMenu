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
import QuartzCore

/**
 The `FlowingMenuTransitionManager` is a concrete subclass of
 `UIPercentDrivenInteractiveTransition` which aims to drive the transition between
 two views by providing an flowing/elastic and bouncing animation effect.

 You must adopt the `FlowingMenuDelegate` if you want to make the transition
 interactive.
 */
public final class FlowingMenuTransitionManager: UIPercentDrivenInteractiveTransition {
  // MARK: - Specifying the Delegate

  /**
  The delegate for the flowing transition manager.

  The delegate must adopt the `FlowingMenuDelegate` protocol and implement the
  required methods to manage the interactive animations.
  */
  public weak var delegate: FlowingMenuDelegate?

  // MARK: - Managing the Animation Mode

  /// Defines the animation mode of the transition.
  enum AnimationMode {
    /// Present the menu mode.
    case Presentation
    /// Dismiss the menu mode.
    case Dismissal
  }

  /// The current animation mode.
  var animationMode = AnimationMode.Presentation

  // MARK: - Defining Interactive Components

  /// Flag to know when whether the transition is interactive.
  var interactive = false

  /// Control views aims to build the elastic shape.
  let controlViews = (0 ..< 8).map { _ in UIView() }
  /// Shaper layer used to draw the elastic view.
  let shapeLayer = CAShapeLayer()
  /// Mask to used to create the bubble effect.
  let shapeMaskLayer = CAShapeLayer()
  /// The display link used to create the bouncing effect.
  lazy var displayLink: CADisplayLink = {
    let displayLink    = CADisplayLink(target: self, selector: #selector(FlowingMenuTransitionManager.updateShapeLayer))
    displayLink.paused = true
    displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)

    return displayLink
  }()
  /// Flag to pause/run the display link.
  var animating = false {
    didSet {
      displayLink.paused = !animating
    }
  }

  // MARK: - Working with Animations

  /// Present menu animation.
  func presentMenu(menuView: UIView, otherView: UIView, containerView: UIView, status: FlowingMenuTransitionStatus, duration: NSTimeInterval, completion: () -> Void) {
    // Composing the view
    let ov              = otherView.snapshotViewAfterScreenUpdates(true)
    ov.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]

    containerView.addSubview(ov)
    containerView.addSubview(menuView)

    // Add the tap gesture
    addTapGesture(containerView)

    // Add a mask to the menu to create the bubble effect
    let maskLayer       = CAShapeLayer()
    menuView.layer.mask = maskLayer

    let source      = delegate ?? self
    let menuWidth   = source.flowingMenu(self, widthOfMenuView: menuView)
    let maxSideSize = max(menuView.bounds.width, menuView.bounds.height)
    let beginRect   = CGRectMake(1, menuView.bounds.height / 2 - 1, 2, 2)
    let middleRect  = CGRectMake(-menuWidth, 0, menuWidth * 2, menuView.bounds.height)
    let endRect     = CGRectMake(-maxSideSize, menuView.bounds.height / 2 - maxSideSize, maxSideSize * 2, maxSideSize * 2)

    let beginPath = UIBezierPath(rect: menuView.bounds)
    beginPath.appendPath(UIBezierPath(ovalInRect: beginRect).bezierPathByReversingPath())

    let middlePath = UIBezierPath(rect: menuView.bounds)
    middlePath.appendPath(UIBezierPath(ovalInRect: middleRect).bezierPathByReversingPath())

    let endPath = UIBezierPath(rect: menuView.bounds)
    endPath.appendPath(UIBezierPath(ovalInRect: endRect).bezierPathByReversingPath())

    // Defining the menu frame
    var menuFrame        = menuView.frame
    menuFrame.size.width = menuWidth
    menuView.frame       = menuFrame

    // Start the animations
    if !interactive {
      let bubbleAnim                 = CAKeyframeAnimation(keyPath: "path")
      bubbleAnim.values              = [beginRect, middleRect, endRect].map { UIBezierPath(ovalInRect: $0).CGPath }
      bubbleAnim.keyTimes            = [0, 0.4, 1]
      bubbleAnim.duration            = duration
      bubbleAnim.removedOnCompletion = false
      bubbleAnim.fillMode            = kCAFillModeForwards
      maskLayer.addAnimation(bubbleAnim, forKey: "bubbleAnim")
    }
    else {
      // Last control points help us to know the menu height
      controlViews[7].center = CGPoint(x: 0, y: menuView.bounds.height)

      // Be sure there is no animation running
      shapeMaskLayer.removeAllAnimations()

      // Retrieve the shape color
      let shapeColor = source.colorOfElasticShapeInFlowingMenu(self) ?? menuView.backgroundColor ?? .blackColor()
      shapeMaskLayer.path        = UIBezierPath(rect: ov.bounds).CGPath
      shapeLayer.actions         = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
      shapeLayer.backgroundColor = shapeColor.CGColor
      shapeLayer.fillColor       = shapeColor.CGColor

      // Add the mask to create the bubble effect
      shapeLayer.mask = shapeMaskLayer

      // Add the shape layer to container view
      containerView.layer.addSublayer(shapeLayer)

      // If the container view change, we update the control points parent
      for view in controlViews {
        view.removeFromSuperview()
        containerView.addSubview(view)
      }
    }

    containerView.userInteractionEnabled = false

    UIView.animateWithDuration(duration, animations: { _ in
      menuFrame.origin.x = 0
      menuView.frame     = menuFrame
      otherView.alpha    = 0
      ov.alpha           = 0.4
      }) { _ in
        if self.interactive && !status.transitionWasCancelled() {
          self.interactive = false

          let bubbleAnim                 = CAKeyframeAnimation(keyPath: "path")
          bubbleAnim.values              = [beginRect, middleRect, endRect].map { UIBezierPath(ovalInRect: $0).CGPath }
          bubbleAnim.keyTimes            = [0, 0.4, 1]
          bubbleAnim.duration            = duration
          bubbleAnim.removedOnCompletion = false
          bubbleAnim.fillMode            = kCAFillModeForwards
          maskLayer.addAnimation(bubbleAnim, forKey: "bubbleAnim")

          let anim                 = CAKeyframeAnimation(keyPath: "path")
          anim.values              = [beginPath, middlePath, endPath].map { $0.CGPath }
          anim.keyTimes            = [0, 0.4, 1]
          anim.duration            = duration
          anim.removedOnCompletion = false
          anim.fillMode            = kCAFillModeForwards
          self.shapeMaskLayer.addAnimation(anim, forKey: "bubbleAnim")

          UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
            for view in self.controlViews {
              view.center.x = menuWidth
            }
            }, completion: { _ in
              self.shapeLayer.removeFromSuperlayer()

              containerView.userInteractionEnabled = true

              menuView.layer.mask = nil
              self.animating      = false

              completion()
          })
        }
        else {
          menuView.layer.mask = nil
          self.animating      = false

          containerView.userInteractionEnabled = true

          completion()
        }
    }
  }

  /// Dismiss menu animation.
  func dismissMenu(menuView: UIView, otherView: UIView, containerView: UIView, status: FlowingMenuTransitionStatus, duration: NSTimeInterval, completion: () -> Void) {
    otherView.frame = containerView.bounds
    let ov          = otherView.snapshotViewAfterScreenUpdates(true)

    var menuFrame = menuView.frame

    containerView.addSubview(otherView)
    containerView.addSubview(ov)
    containerView.addSubview(menuView)

    otherView.alpha = 0
    ov.alpha        = 0.4

    UIView.animateWithDuration(duration, delay: 0, options: [.CurveEaseOut], animations: {
      menuFrame.origin.x = -menuFrame.width
      menuView.frame     = menuFrame
      
      otherView.alpha = 1
      ov.alpha        = 1
      }) { _ in
        completion()
    }
  }
}