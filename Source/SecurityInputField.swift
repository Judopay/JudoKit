//
//  SecurityTextField.swift
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
 
 The SecurityInputField is an input field configured to detect, validate and present security numbers of various types of credit cards.
 
 */
open class SecurityInputField: JudoPayInputField {
    
    /// The card network for the security input field
    open var cardNetwork: CardNetwork = .unknown
    
    /// if it is a token payment, a different hint label text should appear
    open var isTokenPayment: Bool = false
    
    
    override func setupView() {
        self.textField.isSecureTextEntry = true
        super.setupView()
    }
    
    // MARK: UITextFieldDelegate Methods
    
    
    /**
    Delegate method implementation
    
    - parameter textField: Text field
    - parameter range:     Range
    - parameter string:    String
    
    - returns: Boolean to change characters in given range for a textfield
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
        
        if newString.characters.count == 0 {
            return true
        }
        
        return newString.isNumeric() && newString.characters.count <= self.cardNetwork.securityCodeLength()
    }
    
    // MARK: Custom methods
    
    
    /**
    Check if this input field is valid
    
    - returns: True if valid input
    */
    open override func isValid() -> Bool {
        return self.textField.text?.characters.count == self.cardNetwork.securityCodeLength()
    }
    
    
    /**
     Subclassed method that is called when text field content was changed
     
     - parameter textField: The text field of which the content has changed
     */
    open override func textFieldDidChangeValue(_ textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        self.didChangeInputText()
        guard let text = textField.text else { return }
        
        self.delegate?.judoPayInput(self, isValid: text.characters.count == self.cardNetwork.securityCodeLength())
    }
    
    
    /**
     The placeholder string for the current input field
     
     - returns: An Attributed String that is the placeholder of the receiver
     */
    open override func placeholder() -> NSAttributedString? {
        return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:self.theme.getPlaceholderTextColor()])
    }
    
    
    /**
     Boolean indicating whether the receiver has to show a logo
     
     - returns: True if input field shows a Logo
     */
    open override func containsLogo() -> Bool {
        return true
    }
    
    
    /**
     If the receiving input field contains a logo, this method returns Some
     
     - returns: An optional CardLogoView
     */
    open override func logoView() -> CardLogoView? {
        let type: CardLogoType = self.cardNetwork == .amex ? .cid : .cvc
        return CardLogoView(type: type)
    }
    
    
    /**
     Title of the receiver input field
     
     - returns: A string that is the title of the receiver
     */
    open override func title() -> String {
        return self.cardNetwork.securityCodeTitle()
    }
    
    
    /**
     Hint label text
     
     - returns: String that is shown as a hint when user resides in a input field for more than 5 seconds
     */
    open override func hintLabelText() -> String {
        if isTokenPayment {
            return "Re-enter security code"
        }
        return "Security code"
    }

}
