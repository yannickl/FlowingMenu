//
//  FlowingMenuUITests.swift
//  FlowingMenuUITests
//
//  Created by Yannick LORIOT on 04/12/15.
//  Copyright © 2015 Yannick LORIOT. All rights reserved.
//

import XCTest

class FlowingMenuUITests: XCTestCase {
  override func setUp() {
    super.setUp()

    continueAfterFailure = false

    XCUIApplication().launch()
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }

  func testTransition() {
    let app = XCUIApplication()
    app.navigationBars["Contacts"].buttons["picto chat"].tap()

    let tablesQuery = app.tables
    tablesQuery.staticTexts["Inmaculada Cortes"].tap()
    app.navigationBars["Chat"].buttons["picto back"].tap()

    tablesQuery.cells.containing(.staticText, identifier:"Silvia Herrero").staticTexts["Work"].tap()
  }
}
