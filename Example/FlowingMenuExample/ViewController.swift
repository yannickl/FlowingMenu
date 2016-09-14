//
//  ViewController.swift
//  FlowingMenuExample
//
//  Created by Yannick LORIOT on 02/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, FlowingMenuDelegate {
  @IBOutlet weak var topBar: UINavigationBar!
  @IBOutlet weak var userTableView: UITableView!
  @IBOutlet var flowingMenuTransitionManager: FlowingMenuTransitionManager!

  let PresentSegueName = "PresentMenuSegue"
  let DismissSegueName = "DismissMenuSegue"
  let CellName         = "UserContactCell"

  let users          = User.dummyUsers()
  let mainColor      = UIColor(hex: 0x804C5F)
  let derivatedColor = UIColor(hex: 0x794759)

  var menu: UIViewController?

  override func viewDidLoad() {
    super.viewDidLoad()

    flowingMenuTransitionManager.setInteractivePresentationView(view)
    flowingMenuTransitionManager.delegate = self

    topBar.tintColor              = .white
    topBar.barTintColor           = mainColor
    topBar.titleTextAttributes    = [
      NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 22)!,
      NSForegroundColorAttributeName: UIColor.white
    ]
    userTableView.backgroundColor = mainColor
    view.backgroundColor          = mainColor
  }

  // MARK: - Interacting with Storyboards and Segues


  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == PresentSegueName {
      let vc                   = segue.destination
      vc.transitioningDelegate = flowingMenuTransitionManager

      flowingMenuTransitionManager.setInteractiveDismissView(vc.view)

      menu = vc
    }
  }

  @IBAction func unwindToMainViewController(_ sender: UIStoryboardSegue) {
  }

  // MARK: - Managing the Status Bar

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  // MARK: - FlowingMenu Delegate Methods

  func colorOfElasticShapeInFlowingMenu(_ flowingMenu: FlowingMenuTransitionManager) -> UIColor? {
    return mainColor
  }

  func flowingMenuNeedsPresentMenu(_ flowingMenu: FlowingMenuTransitionManager) {
    performSegue(withIdentifier: PresentSegueName, sender: self)
  }

  func flowingMenuNeedsDismissMenu(_ flowingMenu: FlowingMenuTransitionManager) {
    menu?.performSegue(withIdentifier: DismissSegueName, sender: self)
  }

  // MARK: - UITableView DataSource Methods

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellName) as! UserContactCellView

    let user = users[(indexPath as NSIndexPath).row]

    cell.displayNameLabel.text = user.displayName()
    cell.avatarImageView.image = user.avatarImage()

    cell.contentView.backgroundColor = (indexPath as NSIndexPath).row % 2 == 0 ? derivatedColor : mainColor
    
    return cell
  }
}

