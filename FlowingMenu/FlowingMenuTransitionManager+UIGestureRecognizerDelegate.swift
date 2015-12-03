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

  // MARK: - Responding to Gesture Events

  func panToPresentAction(pan: UIScreenEdgePanGestureRecognizer) {
    let view        = pan.view!
    let translation = pan.translationInView(view)

    let percentage = min(max(translation.x / (menuWidth / 2), 0), 1)

    switch pan.state {
    case .Began:
      shapeMaskLayer.path = UIBezierPath(rect: view.bounds).CGPath
      
      controlPoints.0.removeFromSuperview()
      controlPoints.1.removeFromSuperview()
      controlPoints.2.removeFromSuperview()
      controlPoints.3.removeFromSuperview()
      controlPoints.4.removeFromSuperview()
      controlPoints.5.removeFromSuperview()
      controlPoints.6.removeFromSuperview()

      view.addSubview(controlPoints.0)
      view.addSubview(controlPoints.1)
      view.addSubview(controlPoints.2)
      view.addSubview(controlPoints.3)
      view.addSubview(controlPoints.4)
      view.addSubview(controlPoints.5)
      view.addSubview(controlPoints.6)

      interactive = true

      delegate?.flowingMenuInteractiveTransitionWillPresent(self)

      fallthrough
    case .Changed:
      updateInteractiveTransition(percentage)

      let waveWidth = translation.x * 0.9
      let baseWidth = waveWidth * 0.1

      let locationY = pan.locationInView(pan.view).y

      layoutControlPoints(baseWidth, waveWidth: waveWidth, locationY: locationY)

      updateShapeLayer()
    default:
      if percentage < 1 {
        let locationY = pan.locationInView(pan.view).y
        
        layoutControlPoints(0, waveWidth: 0, locationY: locationY)

        animating = true

        cancelInteractiveTransition()
      }
      else {
        finishInteractiveTransition()
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

  // MARK: -

  func currentPath() -> CGPath {
    let bezierPath = UIBezierPath()

    bezierPath.moveToPoint(CGPoint(x: 0, y: 0))
    bezierPath.addLineToPoint(CGPoint(x: controlPoints.0.dg_center(animating).x, y: 0))
    bezierPath.addCurveToPoint(controlPoints.2.dg_center(animating), controlPoint1: controlPoints.0.dg_center(animating), controlPoint2: controlPoints.1.dg_center(animating))
    bezierPath.addCurveToPoint(controlPoints.4.dg_center(animating), controlPoint1: controlPoints.3.dg_center(animating), controlPoint2: controlPoints.4.dg_center(animating))
    bezierPath.addCurveToPoint(controlPoints.6.dg_center(animating), controlPoint1: controlPoints.4.dg_center(animating), controlPoint2: controlPoints.5.dg_center(animating))
    bezierPath.addLineToPoint(CGPoint(x: 0, y: 667))

    bezierPath.closePath()

    return bezierPath.CGPath
  }

  func updateShapeLayer() {
    shapeLayer.path = currentPath()
  }

  func layoutControlPoints(baseWidth: CGFloat, waveWidth: CGFloat, locationY: CGFloat) {
    let height = CGFloat(667)

    let minTopY    = min((locationY - height / 2) * 0.28, 0)
    let maxBottomY = max(height + (locationY - height / 2) * 0.28, height)

    let leftPartWidth  = locationY - minTopY
    let rightPartWidth = maxBottomY - locationY

    controlPoints.0.center = CGPoint(x: baseWidth, y: minTopY)
    controlPoints.1.center = CGPoint(x: baseWidth, y: minTopY + leftPartWidth * 0.44)
    controlPoints.2.center = CGPoint(x: baseWidth + waveWidth * 0.64, y: minTopY + leftPartWidth * 0.71)
    controlPoints.3.center = CGPoint(x: baseWidth + waveWidth * 1.36, y: locationY)
    controlPoints.4.center = CGPoint(x: baseWidth + waveWidth * 0.64, y: maxBottomY - rightPartWidth * 0.71)
    controlPoints.5.center = CGPoint(x: baseWidth, y: maxBottomY - (rightPartWidth * 0.44))
    controlPoints.6.center = CGPoint(x: baseWidth, y: height)
  }
}

extension UIView {
  func dg_center(usePresentationLayerIfPossible: Bool) -> CGPoint {
    if usePresentationLayerIfPossible, let presentationLayer = layer.presentationLayer() as? CALayer {
      return presentationLayer.position
    }

    return center
  }
}
