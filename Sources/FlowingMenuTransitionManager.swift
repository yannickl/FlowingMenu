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
    case presentation
    /// Dismiss the menu mode.
    case dismissal
  }

  /// The current animation mode.
  var animationMode = AnimationMode.presentation

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
    displayLink.isPaused = true
    displayLink.add(to: RunLoop.main, forMode: RunLoopMode.defaultRunLoopMode)

    return displayLink
  }()
  /// Flag to pause/run the display link.
  var animating = false {
    didSet {
      displayLink.isPaused = !animating
    }
  }

  // MARK: - Working with Animations

  /// Present menu animation.
  func presentMenu(_ menuView: UIView, otherView: UIView, containerView: UIView, status: FlowingMenuTransitionStatus, duration: TimeInterval, completion: @escaping () -> Void) {
    // Composing the view
    guard let ov = otherView.snapshotView(afterScreenUpdates: true) else { return }

    ov.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    containerView.addSubview(ov)
    containerView.addSubview(menuView)

    // Add the tap gesture
    addTapGesture(ov)

    // Add a mask to the menu to create the bubble effect
    let maskLayer       = CAShapeLayer()
    menuView.layer.mask = maskLayer

    let source      = delegate ?? self
    let menuWidth   = source.flowingMenu(self, widthOfMenuView: menuView)
    let maxSideSize = max(menuView.bounds.width, menuView.bounds.height)
    let beginRect   = CGRect(x: 1, y: menuView.bounds.height / 2 - 1, width: 2, height: 2)
    let middleRect  = CGRect(x: -menuWidth, y: 0, width: menuWidth * 2, height: menuView.bounds.height)
    let endRect     = CGRect(x: -maxSideSize, y: menuView.bounds.height / 2 - maxSideSize, width: maxSideSize * 2, height: maxSideSize * 2)

    let beginPath = UIBezierPath(rect: menuView.bounds)
    beginPath.append(UIBezierPath(ovalIn: beginRect).reversing())

    let middlePath = UIBezierPath(rect: menuView.bounds)
    middlePath.append(UIBezierPath(ovalIn: middleRect).reversing())

    let endPath = UIBezierPath(rect: menuView.bounds)
    endPath.append(UIBezierPath(ovalIn: endRect).reversing())

    // Defining the menu frame
    var menuFrame        = menuView.frame
    menuFrame.size.width = menuWidth
    menuView.frame       = menuFrame

    // Start the animations
    if !interactive {
      let bubbleAnim                 = CAKeyframeAnimation(keyPath: "path")
      bubbleAnim.values              = [beginRect, middleRect, endRect].map { UIBezierPath(ovalIn: $0).cgPath }
      bubbleAnim.keyTimes            = [0, 0.4, 1]
      bubbleAnim.duration            = duration
      bubbleAnim.isRemovedOnCompletion = false
      bubbleAnim.fillMode            = kCAFillModeForwards
      maskLayer.add(bubbleAnim, forKey: "bubbleAnim")
    }
    else {
      // Last control points help us to know the menu height
      controlViews[7].center = CGPoint(x: 0, y: menuView.bounds.height)

      // Be sure there is no animation running
      shapeMaskLayer.removeAllAnimations()

      // Retrieve the shape color
      let shapeColor = source.colorOfElasticShapeInFlowingMenu(self) ?? menuView.backgroundColor ?? .black
      shapeMaskLayer.path        = UIBezierPath(rect: ov.bounds).cgPath
      shapeLayer.actions         = ["position" : NSNull(), "bounds" : NSNull(), "path" : NSNull()]
      shapeLayer.backgroundColor = shapeColor.cgColor
      shapeLayer.fillColor       = shapeColor.cgColor

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

    containerView.isUserInteractionEnabled = false

    UIView.animate(withDuration: duration, animations: { 
      menuFrame.origin.x = 0
      menuView.frame     = menuFrame
      otherView.alpha    = 0
      ov.alpha           = 0.4
    }) { _ in
      if self.interactive && !status.transitionWasCancelled() {
        self.interactive = false

        let bubbleAnim                 = CAKeyframeAnimation(keyPath: "path")
        bubbleAnim.values              = [beginRect, middleRect, endRect].map { UIBezierPath(ovalIn: $0).cgPath }
        bubbleAnim.keyTimes            = [0, 0.4, 1]
        bubbleAnim.duration            = duration
        bubbleAnim.isRemovedOnCompletion = false
        bubbleAnim.fillMode            = kCAFillModeForwards
        maskLayer.add(bubbleAnim, forKey: "bubbleAnim")

        let anim                 = CAKeyframeAnimation(keyPath: "path")
        anim.values              = [beginPath, middlePath, endPath].map { $0.cgPath }
        anim.keyTimes            = [0, 0.4, 1]
        anim.duration            = duration
        anim.isRemovedOnCompletion = false
        anim.fillMode            = kCAFillModeForwards
        self.shapeMaskLayer.add(anim, forKey: "bubbleAnim")

        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0, options: [], animations: {
          for view in self.controlViews {
            view.center.x = menuWidth
          }
          }, completion: { _ in
            self.shapeLayer.removeFromSuperlayer()

            containerView.isUserInteractionEnabled = true

            menuView.layer.mask = nil
            self.animating      = false

            completion()
        })
      }
      else {
        menuView.layer.mask = nil
        self.animating      = false

        containerView.isUserInteractionEnabled = true

        completion()
      }
    }
  }

  /// Dismiss menu animation.
  func dismissMenu(_ menuView: UIView, otherView: UIView, containerView: UIView, status: FlowingMenuTransitionStatus, duration: TimeInterval, completion: @escaping () -> Void) {
    otherView.frame = containerView.bounds
    let ov          = otherView.snapshotView(afterScreenUpdates: true)

    var menuFrame = menuView.frame

    containerView.addSubview(otherView)
    containerView.addSubview(ov!)
    containerView.addSubview(menuView)

    otherView.alpha = 0
    ov?.alpha       = 0.4

    UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseOut], animations: {
      menuFrame.origin.x = -menuFrame.width
      menuView.frame     = menuFrame
      
      otherView.alpha = 1
      ov?.alpha       = 1
    }) { _ in
      completion()
    }
  }
}
