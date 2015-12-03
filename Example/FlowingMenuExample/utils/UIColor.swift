//
//  UIColor.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 03/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import UIKit

extension UIColor {
  /**
   Creates a color from an hex int.

   - parameter hexString: A hexa-decimal color number representation.
   */
  convenience init(hex: UInt32) {
    let mask = 0x000000FF

    let r = Int(hex >> 16) & mask
    let g = Int(hex >> 8) & mask
    let b = Int(hex) & mask

    let red   = CGFloat(r) / 255
    let green = CGFloat(g) / 255
    let blue  = CGFloat(b) / 255

    self.init(red:red, green:green, blue:blue, alpha:1)
  }
}
