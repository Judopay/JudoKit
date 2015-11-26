//
//  JudoKitTokenPaymentTests.swift
//  JudoKitSwiftExample
//
//  Created by Hamon Riazy on 25/11/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import XCTest

class JudoKitTokenPaymentTests: XCTestCase {
        
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
    
    func testVISATokenPayment() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery.staticTexts["to be stored for future transactions"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.textFields["Card number"].typeText("4976000000003436")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1215")
        
        let cvv2TextField = elementsQuery.textFields["CVV2"]
        cvv2TextField.typeText("452")
        
        app.buttons["Add card"].tap()
        
        let tableQuery = tablesQuery.staticTexts["Token payment"]
        let tableQueryExistsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(tableQueryExistsPredicate, evaluatedWithObject: tableQuery, handler: nil)
        waitForExpectationsWithTimeout(15, handler: nil)
        
        tableQuery.tap()
        cvv2TextField.typeText("452")
        
        app.childrenMatchingType(.Window).elementBoundByIndex(0).childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.childrenMatchingType(.Other).element.buttons["Pay"].tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectationForPredicate(existsPredicate, evaluatedWithObject: button, handler: nil)
        waitForExpectationsWithTimeout(15, handler: nil)
        
        button.tap()
    }
    
}
