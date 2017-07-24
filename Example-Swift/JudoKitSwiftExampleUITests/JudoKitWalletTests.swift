//
//  JudoKitWalletTests.swift
//  JudoKitSwiftExample
//
//  Copyright (c) 2017 Alternative Payments Ltd
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

class JudoKitWalletTests: XCTestCase {
    
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
    
    func testAddWalletCard() {
        
        let app = XCUIApplication()
        app.tables.staticTexts["to manage your cards"].tap()
        
        //Tap on Add a card cell
        app.tables.staticTexts["Add a card"].tap()
        
        //Type all card info
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.secureTextFields["Card number"].typeText("4976000000003436")
        
        elementsQuery.textFields["Expiry date"].typeText("1220")
        
        elementsQuery.secureTextFields["CVV2"].typeText("452")
        
//        let cardName = elementsQuery.textFields["Name this card (optional)"]
        
//        cardName.typeText("My first Visa card")
        
        app.navigationBars["Add card"].buttons["Add"].tap()
        
    }
    
    func deleteCard(){
        //Precondition - create a new card
        testAddWalletCard()
        
        let app = XCUIApplication()
        
        //Tap on just created card cell
        app.tables.staticTexts["Visa"].tap()
        
        //Click on delete nav button
        app.navigationBars["Edit"].buttons["Delete"].tap()
    }
    
}
