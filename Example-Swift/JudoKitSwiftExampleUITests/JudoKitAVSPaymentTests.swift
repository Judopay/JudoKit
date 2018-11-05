//
//  JudoKitAVSPaymentTests.swift
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

class JudoKitAVSPaymentTests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    func testVISAPaymentAVS() {
        let app = XCUIApplication()
        app.toolbars.buttons["Settings"].tap()

        let avsSwitch = app.switches["0"]
        avsSwitch.tap()
        app.buttons["Close"].tap()

        app.tables.staticTexts["Payment"].tap()

        let otherElements = app.scrollViews.otherElements
        otherElements.secureTextFields["Card number"].typeText("4976000000003436")

        let expiryDateTextField = otherElements.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")

        let cvv2TextField = otherElements.secureTextFields["CVV2"]
        cvv2TextField.typeText("452")

        let postCodeTextField = otherElements.textFields["Billing Postcode"]
        postCodeTextField.typeText("TR148PA")

        app.navigationBars["Payment"].buttons["Pay"].tap()

        let homeButton = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")

        expectation(for: existsPredicate, evaluatedWith: homeButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)

        homeButton.tap()
    }

    func testMasterCardPaymentAVS() {
        let app = XCUIApplication()
        app.toolbars.buttons["Settings"].tap()

        let avsSwitch = app.switches["0"]
        avsSwitch.tap()
        app.buttons["Close"].tap()

        app.tables.staticTexts["Payment"].tap()

        let otherElements = app.scrollViews.otherElements
        otherElements.secureTextFields["Card number"].typeText("5100000000005460")

        let expiryDateTextField = otherElements.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")

        let cvc2TextField = otherElements.secureTextFields["CVC2"]
        cvc2TextField.typeText("524")

        let postCodeTextField = otherElements.textFields["Billing Postcode"]
        postCodeTextField.typeText("S205EJ")

        app.navigationBars["Payment"].buttons["Pay"].tap()

        let homeButton = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")

        expectation(for: existsPredicate, evaluatedWith: homeButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)

        homeButton.tap()
    }

    func testAMEXPaymentAVS() {
        let app = XCUIApplication()
        app.toolbars.buttons["Settings"].tap()

        let avsSwitch = app.switches["0"]
        avsSwitch.tap()
        app.buttons["Close"].tap()

        app.tables.staticTexts["Payment"].tap()

        let otherElements = app.scrollViews.otherElements
        let cardNumberTextField = otherElements.secureTextFields["Card number"]
        cardNumberTextField.typeText("340000432128428")

        let expiryDateTextField = otherElements.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")

        let cidTextField = otherElements.secureTextFields["CID"]
        cidTextField.typeText("3469")

        let postCodeTextField = otherElements.textFields["Billing Postcode"]
        postCodeTextField.typeText("NW67BB")

        app.navigationBars["Payment"].buttons["Pay"].tap()

        let homeButton = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")

        expectation(for: existsPredicate, evaluatedWith: homeButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)

        homeButton.tap()
    }

    func testVISAInCanadaPayment() {
        let app = XCUIApplication()
        app.toolbars.buttons["Settings"].tap()

        let avsSwitch = app.switches["0"]
        avsSwitch.tap()
        app.buttons["Close"].tap()

        app.tables.staticTexts["Payment"].tap()

        let otherElements = app.scrollViews.otherElements
        otherElements.secureTextFields["Card number"].typeText("4976000000003436")

        let expiryDateTextField = otherElements.textFields["Expiry date"]
        expiryDateTextField.typeText("1220")

        let cvv2TextField = otherElements.secureTextFields["CVV2"]
        cvv2TextField.typeText("452")

        let countryTextField = otherElements.textFields["Billing country"]
        countryTextField.tap()
        app.pickerWheels.element.adjust(toPickerWheelValue: "Canada")

        let postCodeTextField = otherElements.textFields["Billing Postal code"]
        postCodeTextField.tap()
        postCodeTextField.typeText("K1K2C5")

        app.navigationBars["Payment"].buttons["Pay"].tap()

        let homeButton = app.buttons["Home"]
        let existsPredicate = NSPredicate(format: "exists == 1")

        expectation(for: existsPredicate, evaluatedWith: homeButton, handler: nil)
        waitForExpectations(timeout: 15, handler: nil)

        homeButton.tap()
    }
}
