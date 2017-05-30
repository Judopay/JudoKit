//
//  PostCodeInputField.swift
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

let kUSARegexString = "(^\\d{5}$)|(^\\d{5}-\\d{4}$)"
let kUKRegexString = "(GIR 0AA)|((([A-Z-[QVX]][0-9][0-9]?)|(([A-Z-[QVX]][A-Z-[IJZ]][0-9][0-9]?)|(([A-Z-[QVX‌​]][0-9][A-HJKSTUW])|([A-Z-[QVX]][A-Z-[IJZ]][0-9][ABEHMNPRVWXY]))))\\s?[0-9][A-Z-[C‌​IKMOV]]{2})"
let kCanadaRegexString = "[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9]"

/**
 
 The PostCodeInputField is an input field configured to detect, validate and present post codes of various countries.
 
 */
open class PostCodeInputField: JudoPayInputField {
    
    var billingCountry: BillingCountry = .uk {
        didSet {
            switch billingCountry {
            case .uk, .canada:
                self.textField.keyboardType = .default
            default:
                self.textField.keyboardType = .numberPad
            }
            self.textField.placeholder = "Billing " + self.billingCountry.titleDescription()
        }
    }
    
    override func setupView() {
        super.setupView()
        self.textField.keyboardType = .default
        self.textField.autocapitalizationType = .allCharacters
        self.textField.autocorrectionType = .no
    }
    
    
    /**
     Delegate method implementation
     
     - parameter textField: Text field
     - parameter range:     Range
     - parameter string:    String
     
     - returns: Boolean to change characters in given range for a text field
     */
    open func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Only handle delegate calls for own text field
        guard textField == self.textField else { return false }
        
        // Get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).replacingCharacters(in: range, with: string)
        
        if newString.characters.count == 0 {
            return true
        }
        
        switch billingCountry {
        case .uk:
            return newString.isAlphaNumeric() && newString.characters.count <= 8
        case .canada:
            return newString.isAlphaNumeric() && newString.characters.count <= 6
        case .usa:
            return newString.isNumeric() && newString.characters.count <= 5
        default:
            return newString.isNumeric() && newString.characters.count <= 8
        }
    }
    
    // MARK: Custom methods
    
    
    /**
    Check if this input field is valid
    
    - returns: True if valid input
    */
    open override func isValid() -> Bool {
        if self.billingCountry == .other {
            return true
        }
        guard let newString = self.textField.text?.uppercased() else { return false }
        
        let usaRegex = try! NSRegularExpression(pattern: kUSARegexString, options: .anchorsMatchLines)
        let ukRegex = try! NSRegularExpression(pattern: kUKRegexString, options: .anchorsMatchLines)
        let canadaRegex = try! NSRegularExpression(pattern: kCanadaRegexString, options: .anchorsMatchLines)
        
        switch billingCountry {
        case .uk:
            return ukRegex.numberOfMatches(in: newString, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, newString.characters.count)) > 0
        case .canada:
            return canadaRegex.numberOfMatches(in: newString, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, newString.characters.count)) > 0 && newString.characters.count == 6
        case .usa:
            return usaRegex.numberOfMatches(in: newString, options: NSRegularExpression.MatchingOptions.withoutAnchoringBounds, range: NSMakeRange(0, newString.characters.count)) > 0
        case .other:
            return newString.isNumeric() && newString.characters.count <= 8
        }
    }
    
    
    /**
     Subclassed method that is called when text field content was changed
     
     - parameter textField: The text field of which the content has changed
     */
    open override func textFieldDidChangeValue(_ textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        
        self.didChangeInputText()
        
        let valid = self.isValid()
        
        self.delegate?.judoPayInput(self, isValid: valid)
        
        if !valid {
            guard let characterCount = self.textField.text?.characters.count else { return }
            switch billingCountry {
            case .uk where characterCount >= 7, .canada where characterCount >= 6:
                self.errorAnimation(true)
                self.delegate?.postCodeInputField(self, didEnterInvalidPostCodeWithError: JudoError(.invalidPostCode, "Check " + self.billingCountry.titleDescription()))
            default:
                return
            }
        }
        
    }
    
    
    /**
     Title of the receiver input field
     
     - returns: A string that is the title of the receiver
     */
    open override func title() -> String {
        return "Billing " + self.billingCountry.titleDescription()
    }
    
    
    /**
     Width of the title
     
     - returns: Width of the title
     */
    open override func titleWidth() -> Int {
        return 120
    }
    
}
