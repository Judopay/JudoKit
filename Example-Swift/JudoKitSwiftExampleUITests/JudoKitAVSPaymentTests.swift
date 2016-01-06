//
//  JudoKitAVSPaymentTests.swift
//  JudoKitSwiftExample
//
//  Created by Hamon Riazy on 25/11/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest

class JudoKitAVSPaymentTests: XCTestCase {
        
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
    
    func testVISAPaymentAVS() {
        
        let app = XCUIApplication()
        app.toolbars.buttons["Settings"].tap()
        
        let switch2 = app.switches["0"]
        switch2.tap()
        app.buttons["Close"].tap()
        
        app.tables.staticTexts["with default settings"].tap()

        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("4976000000003436")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cvv2TextField = elementsQuery.textFields["CVV2"]
        cvv2TextField.typeText("452")
        
        let postCodeTextField = elementsQuery.textFields["Post code"]
        postCodeTextField.typeText("TR148PA")
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.buttons["Pay"].tap()
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: button, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        
        button.tap()
    }
    
    func testMasterCardPaymentAVS() {
        
        let app = XCUIApplication()
        app.toolbars.buttons["Settings"].tap()
        
        let switch2 = app.switches["0"]
        switch2.tap()
        app.buttons["Close"].tap()
        
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("5100000000005460")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cvv2TextField = elementsQuery.textFields["CVC2"]
        cvv2TextField.typeText("524")
        
        let postCodeTextField = elementsQuery.textFields["Post code"]
        postCodeTextField.typeText("S205EJ")
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.buttons["Pay"].tap()
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: button, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        
        button.tap()
    }
    
    func testAMEXPayment() {
        let app = XCUIApplication()
        app.toolbars.buttons["Settings"].tap()
        
        let switch2 = app.switches["0"]
        switch2.tap()
        app.buttons["Close"].tap()
        
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let cardNumberTextField = elementsQuery.textFields["Card number"]
        cardNumberTextField.typeText("340000432128428")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cidvTextField = elementsQuery.textFields["CIDV"]
        cidvTextField.typeText("3469")
        
        let postCodeTextField = elementsQuery.textFields["Post code"]
        postCodeTextField.typeText("NW67BB")
        
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.buttons["Pay"].tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: button, handler: nil)
        waitForExpectationsWithTimeout(10, handler: nil)
        
        button.tap()
    }
    
}
