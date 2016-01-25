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
import Judo

let kUSARegexString = "(^\\d{5}$)|(^\\d{5}-\\d{4}$)"
let kUKRegexString = "(GIR 0AA)|((([A-Z-[QVX]][0-9][0-9]?)|(([A-Z-[QVX]][A-Z-[IJZ]][0-9][0-9]?)|(([A-Z-[QVX‌​]][0-9][A-HJKSTUW])|([A-Z-[QVX]][A-Z-[IJZ]][0-9][ABEHMNPRVWXY]))))\\s?[0-9][A-Z-[C‌​IKMOV]]{2})"
let kCanadaRegexString = "[ABCEGHJKLMNPRSTVXY][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9][ABCEGHJKLMNPRSTVWXYZ][0-9]"

/**
 
 The PostCodeInputField is an input field configured to detect, validate and present post codes of various countries.
 
 */
public class PostCodeInputField: JudoPayInputField {
    
    var billingCountry: BillingCountry = .UK {
        didSet {
            switch billingCountry {
            case .UK, .Canada:
                self.textField.keyboardType = .Default
            default:
                self.textField.keyboardType = .NumberPad
            }
            self.titleLabel.text = self.billingCountry.titleDescription()
        }
    }
    
    override func setupView() {
        super.setupView()
        self.textField.keyboardType = .Default
        self.textField.autocapitalizationType = .AllCharacters
        self.textField.autocorrectionType = .No
    }
    
    
    /**
     delegate method implementation
     
     - parameter textField: textField
     - parameter range:     range
     - parameter string:    string
     
     - returns: boolean to change characters in given range for a textfield
     */
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // only handle delegate calls for own textfield
        guard textField == self.textField else { return false }
        
        // get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            return true
        }
        
        switch billingCountry {
        case .UK:
            return newString.isAlphaNumeric() && newString.characters.count <= 8
        case .Canada:
            return newString.isAlphaNumeric() && newString.characters.count <= 6
        case .USA:
            return newString.isNumeric() && newString.characters.count <= 5
        default:
            return newString.isNumeric() && newString.characters.count <= 8
        }
    }

    // MARK: Custom methods
    
    
    /**
    check if this inputField is valid
    
    - returns: true if valid input
    */
    override public func isValid() -> Bool {
        guard let newString = self.textField.text?.uppercaseString else { return false }
        
        let usaRegex = try! NSRegularExpression(pattern: kUSARegexString, options: .AnchorsMatchLines)
        let ukRegex = try! NSRegularExpression(pattern: kUKRegexString, options: .AnchorsMatchLines)
        let canadaRegex = try! NSRegularExpression(pattern: kCanadaRegexString, options: .AnchorsMatchLines)
        
        switch billingCountry {
        case .UK:
            return ukRegex.numberOfMatchesInString(newString, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, newString.characters.count)) > 0
        case .Canada:
            return canadaRegex.numberOfMatchesInString(newString, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, newString.characters.count)) > 0 && newString.characters.count == 6
        case .USA:
            return usaRegex.numberOfMatchesInString(newString, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, newString.characters.count)) > 0
        case .Other:
            return newString.isNumeric() && newString.characters.count <= 8
        }
    }
    
    
    /**
     subclassed method that is called when textField content was changed
     
     - parameter textField: the textfield of which the content has changed
     */
    override public func textFieldDidChangeValue(textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        
        self.didChangeInputText()
        
        self.delegate?.judoPayInput(self, isValid: self.isValid())
    }
    
    
    /**
     title of the receiver inputField
     
     - returns: a string that is the title of the receiver
     */
    override public func title() -> String {
        return self.billingCountry.titleDescription()
    }
    
    
    /**
     width of the title
     
     - returns: width of the title
     */
    override public func titleWidth() -> Int {
        return 120
    }
    
}
