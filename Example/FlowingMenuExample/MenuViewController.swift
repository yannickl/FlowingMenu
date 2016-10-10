//
//  MenuViewController.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 03/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import UIKit

final class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  @IBOutlet weak var topBar: UINavigationBar!
  @IBOutlet weak var userTableView: UITableView!
  @IBOutlet weak var backButtonItem: UIBarButtonItem!

  let CellName  = "UserChatCell"
  
  let users     = User.dummyUsers()
  let mainColor = UIColor(hex: 0xC4ABAA)

  override func viewDidLoad() {
    super.viewDidLoad()

    topBar.tintColor              = .black
    topBar.barTintColor           = mainColor
    topBar.titleTextAttributes    = [
      NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!,
      NSForegroundColorAttributeName: UIColor.black
    ]
    userTableView.backgroundColor = mainColor
    view.backgroundColor          = mainColor
  }

  // MARK: - Managing the Status Bar

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: - UITableView DataSource Methods

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellName) as! UserChatCellView

    let user = users[(indexPath as NSIndexPath).row]

    cell.displayNameLabel.text = user.displayName()
    cell.avatarImageView.image = user.avatarImage()
    cell.statusView.isHidden     = !user.newMessage

    cell.contentView.backgroundColor = mainColor

    return cell
  }

  // MARK: - UITableView Delegate Methods

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    print("Select row at \(indexPath)")
  }
}
