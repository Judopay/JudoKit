//
//  JudoKitMaestroTests.swift
//  JudoKitSwiftExample
//
//  Created by Hamon Riazy on 25/11/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest

class JudoKitMaestroTests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testMaestroPayment() {
        let app = XCUIApplication()
        app.tables.staticTexts["with default settings"].tap()

        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("6759000000005462")
        
        let startDateTextField = elementsQuery.textFields["Start date"]
        startDateTextField.tap()
        startDateTextField.typeText("0107")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.tap()
        expiryDateTextField.typeText("1220")
        
        let cvvTextField = elementsQuery.textFields["CVV"]
        cvvTextField.typeText("789")
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: button, handler: nil)
        waitForExpectationsWithTimeout(15, handler: nil)
        
        button.tap()
    }
    
    func testMaestroAVSPayment() {
        let app = XCUIApplication()
        app.toolbars.buttons["Settings"].tap()
        
        let switch2 = app.switches["0"]
        switch2.tap()
        app.buttons["Close"].tap()

        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("6759000000005462")
        
        let startDateTextField = elementsQuery.textFields["Start date"]
        startDateTextField.tap()
        startDateTextField.typeText("0107")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.tap()
        expiryDateTextField.typeText("1220")
        
        let cvvTextField = elementsQuery.textFields["CVV"]
        cvvTextField.typeText("789")
        
        let postCodeTextField = elementsQuery.textFields["Post code"]
        postCodeTextField.typeText("RG48NL")

        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: button, handler: nil)
        waitForExpectationsWithTimeout(15, handler: nil)
        
        button.tap()
    }
    
    func testMaestro3DSPayment() {
        let app = XCUIApplication()
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("6759000000001909")
        
        let startDateTextField = elementsQuery.textFields["Start date"]
        startDateTextField.tap()
        startDateTextField.typeText("0107")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.tap()
        expiryDateTextField.typeText("1220")
        
        let cvvTextField = elementsQuery.textFields["CVV"]
        cvvTextField.typeText("784")
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let submitButton = app.buttons["Submit"]
        let submitExistsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(submitExistsPredicate, evaluatedWithObject: submitButton, handler: nil)
        waitForExpectationsWithTimeout(15, handler: nil)
        
        submitButton.tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: button, handler: nil)
        waitForExpectationsWithTimeout(15, handler: nil)
        
        button.tap()
    }
    
}
