//
//  JudoKit3DSPaymentTests.swift
//  JudoKitSwiftExample
//
//  Created by Hamon Riazy on 25/11/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest

class JudoKit3DSPaymentTests: XCTestCase {
    
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
    
    func testVISA3DSPayment() {
        let app = XCUIApplication()
        
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("4976350000006891")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1215")
        
        let cvv2TextField = elementsQuery.textFields["CVV2"]
        cvv2TextField.typeText("341")
        
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.buttons["Pay"].tap()
        
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
    
    func testMasterCard3DSPayment() {
        let app = XCUIApplication()
        
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("5100000000001907")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1215")
        
        let cvv2TextField = elementsQuery.textFields["CVC2"]
        cvv2TextField.typeText("654")
        
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.buttons["Pay"].tap()
        
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
    
    func testAMEX3DSPayment() {
        let app = XCUIApplication()
        
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("340000061790712")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1215")
        
        let cvv2TextField = elementsQuery.textFields["CIDV"]
        cvv2TextField.typeText("5464")
        
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.buttons["Pay"].tap()
        
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
