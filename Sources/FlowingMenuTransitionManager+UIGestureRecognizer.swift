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
 Here manage the interactive transition mainly thanks to the gestures.
*/
extension FlowingMenuTransitionManager {
  /**
   Defines the given view as interactive to present the menu.
   
   - parameter view: The view used to respond to the gesture events.
  */
  public func setInteractivePresentationView(view: UIView) {
    let screenEdgePanGesture   = UIScreenEdgePanGestureRecognizer()
    screenEdgePanGesture.edges = .Left
    screenEdgePanGesture.addTarget(self, action:#selector(FlowingMenuTransitionManager.panToPresentAction(_:)))

    view.addGestureRecognizer(screenEdgePanGesture)
  }

  /**
   Defines the given view as interactive to dismiss the menu.

   - parameter view: The view used to respond to the gesture events.
   */
  public func setInteractiveDismissView(view: UIView) {
    let panGesture                    = UIPanGestureRecognizer()
    panGesture.maximumNumberOfTouches = 1
    panGesture.addTarget(self, action:#selector(FlowingMenuTransitionManager.panToDismissAction(_:)))

    view.addGestureRecognizer(panGesture)
  }

  /**
   Add the tap gesture to the given view to dismiss it when a tap occurred.

   - parameter view: The view used to respond to the gesture events.
   */
  func addTapGesture(view: UIView) {
    let tapGesture                  = UITapGestureRecognizer()
    tapGesture.numberOfTapsRequired = 1
    tapGesture.addTarget(self, action: #selector(FlowingMenuTransitionManager.tapToDismissAction(_:)))

    view.addGestureRecognizer(tapGesture)
  }

  // MARK: - Responding to Gesture Events

  /**
    The screen edge pan gesture recognizer action methods. It is used to
    present the menu.
  
    - parameter panGesture: The `UIScreenEdgePanGestureRecognizer` sender
    object.
  */
  func panToPresentAction(panGesture: UIScreenEdgePanGestureRecognizer) {
    let view        = panGesture.view!
    let translation = panGesture.translationInView(view)
    let menuWidth   = (delegate ?? self).flowingMenu(self, widthOfMenuView: view)

    let yLocation  = panGesture.locationInView(panGesture.view).y
    let percentage = min(max(translation.x / (menuWidth / 2), 0), 1)

    switch panGesture.state {
    case .Began:
      interactive = true

      // Asking the delegate the present the menu
      delegate?.flowingMenuNeedsPresentMenu(self)

      fallthrough
    case .Changed:
      updateInteractiveTransition(percentage)

      let waveWidth = translation.x * 0.9
      let left      = waveWidth * 0.1

      // Update the control points
      moveControlViewsToPoint(CGPoint(x: left, y: yLocation), waveWidth: waveWidth)

      // Update the shape layer
      updateShapeLayer()
    default:
      animating = true

      if percentage < 1 {
        interactive = false
        
        moveControlViewsToPoint(CGPoint(x: 0, y: yLocation), waveWidth: 0)
        
        cancelInteractiveTransition()
      }
      else {
        finishInteractiveTransition()
      }
    }
  }

  /**
   The pan gesture recognizer action methods. It is used to dismiss the
   menu.

   - parameter panGesture: The `UIPanGestureRecognizer` sender object.
   */
  func panToDismissAction(panGesture: UIPanGestureRecognizer) {
    let view        = panGesture.view!
    let translation = panGesture.translationInView(view)
    let menuWidth   = (delegate ?? self).flowingMenu(self, widthOfMenuView: view)
    
    let percentage = min(max(translation.x / menuWidth * -1, 0), 1)

    switch panGesture.state {
    case .Began:
      interactive = true

      delegate?.flowingMenuNeedsDismissMenu(self)
    case .Changed:
      updateInteractiveTransition(percentage)
    default:
      interactive = false

      if percentage > 0.2 {
        finishInteractiveTransition()
      }
      else {
        cancelInteractiveTransition()
      }
    }
  }

  /**
   The tap gesture recognizer action methods. It is used to dismiss the
   menu.

   - parameter tapGesture: The `UITapGestureRecognizer` sender object.
   */
  func tapToDismissAction(tapGesture: UITapGestureRecognizer) {
    delegate?.flowingMenuNeedsDismissMenu(self)
  }

  // MARK: - Building Paths

  /**
  Returns a bezier path using the control view positions.

  - returns: A bezier path.
  */
  func currentPath() -> CGPath {
    let bezierPath = UIBezierPath()

    bezierPath.moveToPoint(CGPoint(x: 0, y: 0))
    bezierPath.addLineToPoint(CGPoint(x: controlViews[0].center(animating).x, y: 0))
    bezierPath.addCurveToPoint(controlViews[2].center(animating), controlPoint1: controlViews[0].center(animating), controlPoint2: controlViews[1].center(animating))
    bezierPath.addCurveToPoint(controlViews[4].center(animating), controlPoint1: controlViews[3].center(animating), controlPoint2: controlViews[4].center(animating))
    bezierPath.addCurveToPoint(controlViews[6].center(animating), controlPoint1: controlViews[4].center(animating), controlPoint2: controlViews[5].center(animating))
    bezierPath.addLineToPoint(CGPoint(x: 0, y: controlViews[7].center.y))

    bezierPath.closePath()

    return bezierPath.CGPath
  }

  // MARK: - Updating Shapes

  /// Update the shape layer using the current control view positions.
  func updateShapeLayer() {
    shapeLayer.path = currentPath()
  }

  /**
   Move the control view positions using a position and a wave width.
   
   - parameter position: The target position.
   - parameter waveWidth: The wave width in point.
  */
  func moveControlViewsToPoint(position: CGPoint, waveWidth: CGFloat) {
    let height     = controlViews[7].center.y
    let minTopY    = min((position.y - height / 2) * 0.28, 0)
    let maxBottomY = max(height + (position.y - height / 2) * 0.28, height)

    let leftPartWidth  = position.y - minTopY
    let rightPartWidth = maxBottomY - position.y

    controlViews[0].center = CGPoint(x: position.x, y: minTopY)
    controlViews[1].center = CGPoint(x: position.x, y: minTopY + leftPartWidth * 0.44)
    controlViews[2].center = CGPoint(x: position.x + waveWidth * 0.64, y: minTopY + leftPartWidth * 0.71)
    controlViews[3].center = CGPoint(x: position.x + waveWidth * 1.36, y: position.y)
    controlViews[4].center = CGPoint(x: position.x + waveWidth * 0.64, y: maxBottomY - rightPartWidth * 0.71)
    controlViews[5].center = CGPoint(x: position.x, y: maxBottomY - (rightPartWidth * 0.44))
    controlViews[6].center = CGPoint(x: position.x, y: height)
  }
}
