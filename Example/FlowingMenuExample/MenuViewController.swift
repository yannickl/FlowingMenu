//
//  MenuViewController.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 03/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController, UITableViewDataSource {
  @IBOutlet weak var topBar: UINavigationBar!
  @IBOutlet weak var userTableView: UITableView!
  @IBOutlet weak var backButtonItem: UIBarButtonItem!

  let CellName  = "UserChatCell"
  
  let users     = User.dummyUsers()
  let mainColor = UIColor(hex: 0xC4ABAA)

  override func viewDidLoad() {
    super.viewDidLoad()

    topBar.tintColor              = .blackColor()
    topBar.barTintColor           = mainColor
    topBar.titleTextAttributes    = [
      NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!,
      NSForegroundColorAttributeName: UIColor.blackColor()]
    userTableView.backgroundColor = mainColor
    view.backgroundColor          = mainColor
  }

  // MARK: - Managing the Status Bar

  override func preferredStatusBarStyle() -> UIStatusBarStyle {
    return .LightContent
  }

  // MARK: - UITableView DataSource Methods

  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier(CellName) as! UserChatCellView

    let user = users[indexPath.row]

    cell.displayNameLabel.text = user.displayName()
    cell.avatarImageView.image = user.avatarImage()
    cell.statusView.hidden     = !user.newMessage

    cell.contentView.backgroundColor = mainColor

    return cell
  }
}
