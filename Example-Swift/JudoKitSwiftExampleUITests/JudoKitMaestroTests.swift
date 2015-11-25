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
        let cardNumberTextField = elementsQuery.textFields["Card number"]
        cardNumberTextField.tap()
        cardNumberTextField.tap()
        cardNumberTextField.typeText("6759000000005462")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.tap()
        expiryDateTextField.tap()
        expiryDateTextField.typeText("121")
        
        let cvvTextField = elementsQuery.textFields["CVV"]
        cvvTextField.tap()
        cvvTextField.typeText("5789")
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.buttons["Pay"].tap()
        
        let okButton = app.alerts["Error"].collectionViews.buttons["OK"]
        okButton.tap()
        okButton.pressForDuration(0.5);
        
    }
    
}
