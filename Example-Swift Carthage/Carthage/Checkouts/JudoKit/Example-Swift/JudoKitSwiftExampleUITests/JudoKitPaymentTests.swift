//
//  JudoKitPaymentTests.swift
//  JudoKitSwiftExample
//
//  Copyright (c) 2016 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import XCTest

class JudoKitPaymentTests: XCTestCase {
        
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
    
    func testVISAPayment() {
        
        let app = XCUIApplication()
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.secureTextFields["Card number"].typeText("4976000000003436")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cvv2TextField = elementsQuery.secureTextFields["CVV2"]
        cvv2TextField.typeText("452")
        
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        button.tap()
    }
    
    func testMasterCardPayment() {
        let app = XCUIApplication()
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let cardNumberTextField = elementsQuery.secureTextFields["Card number"]
        cardNumberTextField.typeText("5100000000005460")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cvc2TextField = elementsQuery.secureTextFields["CVC2"]
        cvc2TextField.typeText("524")
        
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        button.tap()
    }
    
    func testAMEXPayment() {
        let app = XCUIApplication()
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let cardNumberTextField = elementsQuery.secureTextFields["Card number"]
        cardNumberTextField.typeText("340000432128428")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cidTextField = elementsQuery.secureTextFields["CID"]
        cidTextField.typeText("3469")
        
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        button.tap()
    }
}
