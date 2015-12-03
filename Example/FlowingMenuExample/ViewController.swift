//
//  ViewController.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 02/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
  @IBOutlet weak var topBar: UINavigationBar!
  @IBOutlet weak var userTableView: UITableView!
  @IBOutlet var flowingMenuTransitionManager: FlowingMenuTransitionManager!

  let SegueName = "PresentMenuSegue"
  let CellName  = "UserContactCell"

  let users          = User.dummyUsers()
  let mainColor      = UIColor(hex: 0x804C5F)
  let derivatedColor = UIColor(hex: 0x794759)

  override func viewDidLoad() {
    super.viewDidLoad()

    topBar.tintColor              = .whiteColor()
    topBar.barTintColor           = mainColor
    topBar.titleTextAttributes    = [
      NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!,
      NSForegroundColorAttributeName: UIColor.whiteColor()]
    userTableView.backgroundColor = mainColor
    view.backgroundColor          = mainColor
  }

  // MARK: - Interacting with Storyboards and Segues

  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if segue.identifier == SegueName {
      let vc                   = segue.destinationViewController
      vc.transitioningDelegate = flowingMenuTransitionManager
    }
  }

  @IBAction func unwindToMainViewController (sender: UIStoryboardSegue){
    // bug? exit segue doesn't dismiss so we do it manually...
    //self.dismissViewControllerAnimated(true, completion: nil)
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
    let cell = tableView.dequeueReusableCellWithIdentifier(CellName) as! UserContactCellView

    let user = users[indexPath.row]

    cell.displayNameLabel.text = user.displayName()
    cell.avatarImageView.image = user.avatarImage()

    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? derivatedColor : mainColor

    return cell
  }
}

