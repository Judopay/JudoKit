//
//  CardInputField.swift
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

/**
 
 The CardInputField is an input field configured to detect, validate and present card numbers of various types of credit cards.
 
 */
open class CardInputField: JudoPayInputField {
    
    /// The card network that was detected in this field
    open var cardNetwork: CardNetwork = .unknown
    
    /// if it is a token payment, different validation criteria apply
    open var isTokenPayment: Bool = false
    
    override func setupView() {
        self.textField.isSecureTextEntry = true
        super.setupView()
    }
    
    // MARK: UITextFieldDelegate
    
    /**
    Delegate method implementation
    
    - parameter textField: Text field
    - parameter range:     Range
    - parameter string:    String
    
    - returns: boolean to change characters in given range for a textfield
    */
    open func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Only handle delegate calls for own text field
        guard textField == self.textField else { return false }
        
        if string.characters.count > 0 && self.textField.isSecureTextEntry {
            self.textField.isSecureTextEntry = false
        }
        
        // Get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).replacingCharacters(in: range, with: string)
        
        if newString.characters.count == 0 || string.characters.count == 0 {
            return true
        }
        
        var result: String?
        
        do {
            result = try self.textField.text?.cardPresentationString(self.theme.acceptedCardNetworks)
            self.dismissError()
        } catch let error {
            self.delegate?.cardInput(self, error: error as! JudoError)
        }
        
        if result == nil {
            return false
        }
        
        return true
        
    }
    
    // MARK: Custom methods
    
    /**
    Check if this inputField is valid
    
    - returns: true if valid input
    */
    open override func isValid() -> Bool {
        return self.isTokenPayment || self.textField.text?.isCardNumberValid() ?? false
    }
    
    
    /**
     Subclassed method that is called when textField content was changed
     
     - parameter textField: the textfield of which the content has changed
     */
    open override func textFieldDidChangeValue(_ textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        
        self.didChangeInputText()
        
        do {
            self.textField.text = try self.textField.text?.cardPresentationString(self.theme.acceptedCardNetworks)
            self.delegate?.cardInput(self, didDetectNetwork: textField.text!.cardNetwork())
            self.dismissError()
        } catch let error {
            self.delegate?.cardInput(self, error: error as! JudoError)
        }
        
        let lowestNumber = self.theme.acceptedCardNetworks.filter({ $0.cardNetwork == self.textField.text?.cardNetwork() }).sorted(by: <)
        
        if let textCount = textField.text?.stripped.characters.count , textCount == lowestNumber.first?.cardLength {
            if textField.text!.isCardNumberValid() {
                self.delegate?.cardInput(self, didFindValidNumber: textField.text!)
                self.dismissError()
            } else {
                self.delegate?.cardInput(self, error: JudoError(.invalidCardNumber, "Check card number"))
            }
        }
        
    }
    
    
    /**
     The placeholder string for the current inputField
     
     - returns: an Attributed String that is the placeholder of the receiver
     */
    open override func placeholder() -> NSAttributedString? {
        return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:self.theme.getPlaceholderTextColor()])
    }
    
    
    /**
     Boolean indicating whether the receiver has to show a logo
     
     - returns: true if inputField shows a Logo
     */
    open override func containsLogo() -> Bool {
        return true
    }
    
    
    /**
     If the receiving inputField contains a Logo, this method returns Some
     
     - returns: an optional CardLogoView
     */
    open override func logoView() -> CardLogoView? {
        return CardLogoView(type: self.cardNetwork.cardLogoType())
    }
    
    
    /**
     Title of the receiver inputField
     
     - returns: a string that is the title of the receiver
     */
    open override func title() -> String {
        return "Card number"
    }
    
    
    /**
     Hint label text
     
     - returns: string that is shown as a hint when user resides in a inputField for more than 5 seconds
     */
    open override func hintLabelText() -> String {
        return "Long card number"
    }

}
