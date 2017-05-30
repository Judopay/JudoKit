//
//  JudoPayInputDelegate.swift
//  JudoKit
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

import Foundation

/**
 
 The JudoPayInputDelegate is a delegate protocol that is used to pass information about the state of entering information for making transactions
 
 */
public protocol JudoPayInputDelegate {
    
    /**
     Delegate method that is triggered when the CardInputField encountered an error
     
     - parameter input: The input field calling the delegate method
     - parameter error: The error that occured
     */
    func cardInput(_ input: CardInputField, error: JudoError)
    
    
    /**
     Delegate method that is triggered when the CardInputField did find a valid number
     
     - parameter input:            The input field calling the delegate method
     - parameter cardNumberString: The card number that has been entered as a String
     */
    func cardInput(_ input: CardInputField, didFindValidNumber cardNumberString: String)
    
    
    /**
     Delegate method that is triggered when the CardInputField detected a network
     
     - parameter input:   The input field calling the delegate method
     - parameter network: The network that has been identified
     */
    func cardInput(_ input: CardInputField, didDetectNetwork network: CardNetwork)
    
    
    /**
     Delegate method that is triggered when the date input field has encountered an error
     
     - parameter input: The input field calling the delegate method
     - parameter error: The error that occured
     */
    func dateInput(_ input: DateInputField, error: JudoError)
    
    
    /**
     Delegate method that is triggered when the date input field has found a valid date
     
     - parameter input: The input field calling the delegate method
     - parameter date:  The valid date that has been entered
     */
    func dateInput(_ input: DateInputField, didFindValidDate date: String)
    
    
    /**
     Delegate method that is triggered when the issueNumberInputField entered a code
     
     - parameter input:       The issueNumberInputField calling the delegate method
     - parameter issueNumber: The issue number that has been entered as a String
     */
    func issueNumberInputDidEnterCode(_ input: IssueNumberInputField, issueNumber: String)
    
    
    /**
     Delegate method that is triggered when the billingCountry input field selected a BillingCountry
     
     - parameter input:          The input field calling the delegate method
     - parameter billingCountry: The billing country that has been selected
     */
    func billingCountryInputDidEnter(_ input: BillingCountryInputField, billingCountry: BillingCountry)
    
    
    /**
     Delegate method that is triggered when the post code input field has received an invalid entry
     
     - parameter input: The input field calling the delegate method
     - parameter error: The error that occured
     */
    func postCodeInputField(_ input: PostCodeInputField, didEnterInvalidPostCodeWithError error: JudoError)
    
    
    /**
     Delegate method that is triggered when the judoPayInputField was validated
     
     - parameter input:   The input field calling the delegate method
     - parameter isValid: A boolean that indicates whether the input is valid or invalid
     */
    func judoPayInput(_ input: JudoPayInputField, isValid: Bool)
    
    
    /**
     Delegate method that is called whenever any inputField has been manipulated
     
     - parameter input: The input field calling the delegate method
     */
    func judoPayInputDidChangeText(_ input: JudoPayInputField)
    
}
