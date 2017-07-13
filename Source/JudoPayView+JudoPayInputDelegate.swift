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


extension JudoPayView: JudoPayInputDelegate {
    
    // MARK: CardInputDelegate
    
    
    /**
    Delegate method that is triggered when the CardInputField encountered an error
    
    - parameter input: The input field calling the delegate method
    - parameter error: The error that occured
    */
    public func cardInput(_ input: CardInputField, error: JudoError) {
        input.errorAnimation(error.code != .inputLengthMismatchError)
        if let message = error.message {
            input.displayError(message: message)
        }
    }
    
    
    /**
     Delegate method that is triggered when the CardInputField did find a valid number
     
     - parameter input:            The input field calling the delegate method
     - parameter cardNumberString: The card number that has been entered as a String
     */
    public func cardInput(_ input: CardInputField, didFindValidNumber cardNumberString: String) {
        if input.cardNetwork == .maestro {
            self.startDateInputField.textField.becomeFirstResponder()
        } else {
            self.expiryDateInputField.textField.becomeFirstResponder()
        }
    }
    
    
    /**
     Delegate method that is triggered when the CardInputField detected a network
     
     - parameter input:   The input field calling the delegate method
     - parameter network: The network that has been identified
     */
    public func cardInput(_ input: CardInputField, didDetectNetwork network: CardNetwork) {
        self.updateInputFieldsWithNetwork(network)
        input.displayHint(message: "")
        self.updateSecurityMessagePosition(toggleUp: true)
    }
    
    // MARK: DateInputDelegate
    
    
    /**
    Delegate method that is triggered when the date input field has encountered an error
    
    - parameter input: The input field calling the delegate method
    - parameter error: The error that occured
    */
    public func dateInput(_ input: DateInputField, error: JudoError) {
        input.errorAnimation(error.code != .inputLengthMismatchError)
        if let message = error.message {
            input.displayError(message: message)
        }
    }
    
    
    /**
     Delegate method that is triggered when the date input field has found a valid date
     
     - parameter input: The input field calling the delegate method
     - parameter date:  The valid date that has been entered
     */
    public func dateInput(_ input: DateInputField, didFindValidDate date: String) {
        input.displayHint(message: "")
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
    public func issueNumberInputDidEnterCode(_ inputField: IssueNumberInputField, issueNumber: String) {
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
    public func billingCountryInputDidEnter(_ input: BillingCountryInputField, billingCountry: BillingCountry) {
        self.postCodeInputField.billingCountry = billingCountry
        self.postCodeInputField.textField.text = ""
        self.postCodeInputField.isUserInteractionEnabled = billingCountry != .other
        self.judoPayInputDidChangeText(self.billingCountryInputField)
    }
    
    
    /**
     Delegate method that is triggered when the post code input field encountered an error
     
     - parameter input: The input field calling the delegate method
     - parameter error: The encountered error
     */
    public func postCodeInputField(_ input: PostCodeInputField, didEnterInvalidPostCodeWithError error: JudoError) {
        if let errorMessage = error.message {
            input.displayError(message: errorMessage)
        }
    }
    
    // MARK: JudoPayInputDelegate
    
    
    /**
    Delegate method that is triggered when the judoPayInputField was validated
    
    - parameter input:   The input field calling the delegate method
    - parameter isValid: A boolean that indicates whether the input is valid or invalid
    */
    public func judoPayInput(_ input: JudoPayInputField, isValid: Bool) {
        if input == self.secureCodeInputField {
            if self.theme.avsEnabled {
                if isValid {
                    self.postCodeInputField.textField.becomeFirstResponder()
                    self.toggleAVSVisibility(true, completion: { () -> () in
                        self.contentView.scrollRectToVisible(self.postCodeInputField.frame, animated: true)
                    })
                }
            }
        } else if input == self.postCodeInputField {
            input.displayHint(message: "")
        }
    }
    
    
    /**
     Delegate method that is called whenever any input field has been manipulated
     
     - parameter input: The input field calling the delegate method
     */
    public func judoPayInputDidChangeText(_ input: JudoPayInputField) {
        self.showHintAfterDefaultDelay(input)
        var allFieldsValid = false
        allFieldsValid = (self.cardDetails?.isCardNumberValid ?? false || self.cardInputField.isValid()) && self.expiryDateInputField.isValid() && self.secureCodeInputField.isValid()
        if self.theme.avsEnabled {
            allFieldsValid = allFieldsValid && self.postCodeInputField.isValid() && self.billingCountryInputField.isValid()
        }
        if self.cardInputField.cardNetwork == .maestro {
            allFieldsValid = allFieldsValid && (self.issueNumberInputField.isValid() || self.startDateInputField.isValid())
        }
        self.paymentEnabled(allFieldsValid)
    }
}

