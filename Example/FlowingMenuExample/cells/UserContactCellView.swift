//
//  UserContactCellView.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 03/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import UIKit

final class UserContactCellView: UITableViewCell {
  @IBOutlet weak var avatarImageView: UIImageView! {
    didSet {
      avatarImageView.layer.masksToBounds = true
    }
  }
  @IBOutlet weak var displayNameLabel: UILabel!
  @IBOutlet weak var roleLabel: UILabel!

  override func layoutSubviews() {
    super.layoutSubviews()

    // iOS 10 bug: rdar://27644391
    contentView.layoutSubviews()
    
    avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
  }
}
