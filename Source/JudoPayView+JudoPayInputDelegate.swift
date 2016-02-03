//
//  JudoPayView.swift
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

import UIKit
import Judo

extension JudoPayView: JudoPayInputDelegate {
    
    // MARK: CardInputDelegate
    
    
    /**
    Delegate method that is triggered when the CardInputField encountered an error
    
    - parameter input: The input field calling the delegate method
    - parameter error: The error that occured
    */
    public func cardInput(input: CardInputField, error: JudoError) {
        input.errorAnimation(error.code != .InputLengthMismatchError)
        if let message = error.message {
            self.hintLabel.showAlert(message)
        }
    }
    
    
    /**
     Delegate method that is triggered when the CardInputField did find a valid number
     
     - parameter input:            The input field calling the delegate method
     - parameter cardNumberString: The card number that has been entered as a String
     */
    public func cardInput(input: CardInputField, didFindValidNumber cardNumberString: String) {
        self.expiryDateInputField.textField.becomeFirstResponder()
    }
    
    
    /**
     Delegate method that is triggered when the CardInputField detected a network
     
     - parameter input:   The input field calling the delegate method
     - parameter network: The network that has been identified
     */
    public func cardInput(input: CardInputField, didDetectNetwork network: CardNetwork) {
        self.updateInputFieldsWithNetwork(network)
        self.hintLabel.hideAlert()
    }
    
    // MARK: DateInputDelegate
    
    
    /**
    Delegate method that is triggered when the date input field has encountered an error
    
    - parameter input: The input field calling the delegate method
    - parameter error: The error that occured
    */
    public func dateInput(input: DateInputField, error: JudoError) {
        input.errorAnimation(error.code != .InputLengthMismatchError)
    }
    
    
    /**
     Delegate method that is triggered when the date input field has found a valid date
     
     - parameter input: The input field calling the delegate method
     - parameter date:  The valid date that has been entered
     */
    public func dateInput(input: DateInputField, didFindValidDate date: String) {
        if input == self.startDateInputField {
            self.issueNumberInputField.textField.becomeFirstResponder()
        } else {
            self.secureCodeInputField.textField.becomeFirstResponder()
        }
    }
    
    // MARK: IssueNumberInputDelegate
    
    
    /**
    Delegate method that is triggered when the issueNumberInputField entered a code
    
    - parameter input:       The issueNumberInputField calling the delegate method
    - parameter issueNumber: The issue number that has been entered as a String
    */
    public func issueNumberInputDidEnterCode(inputField: IssueNumberInputField, issueNumber: String) {
        if issueNumber.characters.count == 3 {
            self.expiryDateInputField.textField.becomeFirstResponder()
        }
    }
    
    // MARK: BillingCountryInputDelegate
    
    
    /**
    Delegate method that is triggered when the billing country input field selected a billing country
    
    - parameter input:          The input field calling the delegate method
    - parameter billingCountry: The billing country that has been selected
    */
    public func billingCountryInputDidEnter(input: BillingCountryInputField, billingCountry: BillingCountry) {
        self.postCodeInputField.billingCountry = billingCountry
        // FIXME: maybe check if the postcode is still valid and then delete if nessecary
        self.postCodeInputField.textField.text = ""
    }
    
    // MARK: JudoPayInputDelegate
    
    
    /**
    Delegate method that is triggered when the judoPayInputField was validated
    
    - parameter input:   The input field calling the delegate method
    - parameter isValid: A boolean that indicates whether the input is valid or invalid
    */
    public func judoPayInput(input: JudoPayInputField, isValid: Bool) {
        if input == self.secureCodeInputField {
            if JudoKit.avsEnabled {
                if isValid {
                    self.postCodeInputField.textField.becomeFirstResponder()
                    self.toggleAVSVisibility(true, completion: { () -> () in
                        self.contentView.scrollRectToVisible(self.postCodeInputField.frame, animated: true)
                    })
                }
            }
        }
    }
    
    /**
     Delegate method that is called whenever any input field has been manipulated
     
     - parameter input: The input field calling the delegate method
     */
    public func judoPayInputDidChangeText(input: JudoPayInputField) {
        self.resetTimerWithInput(input)
        var allFieldsValid = false
        allFieldsValid = self.cardInputField.isValid() && self.expiryDateInputField.isValid() && self.secureCodeInputField.isValid()
        if JudoKit.avsEnabled {
            allFieldsValid = allFieldsValid && self.postCodeInputField.isValid() && self.billingCountryInputField.isValid()
        }
        if self.cardInputField.cardNetwork == .Maestro {
            allFieldsValid = allFieldsValid && (self.issueNumberInputField.isValid() || self.startDateInputField.isValid())
        }
        self.paymentEnabled(allFieldsValid)
    }
    
}
