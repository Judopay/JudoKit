//
//  JudoKit3DSPaymentTests.swift
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
        elementsQuery.secureTextFields["Card number"].typeText("4976350000006891")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cvv2TextField = elementsQuery.secureTextFields["CVV2"]
        cvv2TextField.typeText("341")
        
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let submitButton = app.buttons["Submit"]
        let submitExistsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: submitExistsPredicate, evaluatedWith: submitButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        submitButton.tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        button.tap()
        
    }
    
    func testMasterCard3DSPayment() {
        let app = XCUIApplication()
        
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.secureTextFields["Card number"].typeText("5100000000001907")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cvv2TextField = elementsQuery.secureTextFields["CVC2"]
        cvv2TextField.typeText("654")
        
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let submitButton = app.buttons["Submit"]
        let submitExistsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: submitExistsPredicate, evaluatedWith: submitButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        submitButton.tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        button.tap()
        
    }
    
    func testAMEX3DSPayment() {
        let app = XCUIApplication()
        
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.secureTextFields["Card number"].typeText("340000061790712")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")
        
        let cvv2TextField = elementsQuery.secureTextFields["CID"]
        cvv2TextField.typeText("5464")
        
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let submitButton = app.buttons["Submit"]
        let submitExistsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: submitExistsPredicate, evaluatedWith: submitButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        submitButton.tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        button.tap()
        
    }
    
    func testMaestro3DSPayment() {
        let app = XCUIApplication()
        app.tables.staticTexts["with default settings"].tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.secureTextFields["Card number"].typeText("6759000000001909")
        
        let startDateTextField = elementsQuery.textFields["Start date"]
        startDateTextField.tap()
        startDateTextField.typeText("0108")
        
        let expiryDateTextField = elementsQuery.textFields["Expiry date"]
        expiryDateTextField.tap()
        expiryDateTextField.typeText("1220")
        
        let cvvTextField = elementsQuery.secureTextFields["CVV"]
        cvvTextField.typeText("784")
        app.navigationBars["Payment"].buttons["Pay"].tap()
        
        let submitButton = app.buttons["Submit"]
        let submitExistsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: submitExistsPredicate, evaluatedWith: submitButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        submitButton.tap()
        
        let button = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")
        
        expectation(for: existsPredicate, evaluatedWith: button, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)
        
        button.tap()
    }
    
}
