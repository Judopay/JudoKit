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
import Judo

/**
 
 The SecurityInputField is an input field configured to detect, validate and present security numbers of various types of credit cards.
 
 */
public class SecurityInputField: JudoPayInputField {
    
    /// The card network for the security input field
    public var cardNetwork: CardNetwork = .Unknown
    
    /// if it is a token payment, a different hint label text should appear
    public var isTokenPayment: Bool = false
    
    // MARK: UITextFieldDelegate Methods
    
    
    /**
    Delegate method implementation
    
    - parameter textField: Text field
    - parameter range:     Range
    - parameter string:    String
    
    - returns: Boolean to change characters in given range for a textfield
    */
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Only handle delegate calls for own text field
        guard textField == self.textField else { return false }
        
        // Get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
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
    override public func isValid() -> Bool {
        return self.textField.text?.characters.count == self.cardNetwork.securityCodeLength()
    }
    
    
    /**
     Subclassed method that is called when text field content was changed
     
     - parameter textField: The text field of which the content has changed
     */
    override public func textFieldDidChangeValue(textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        self.didChangeInputText()
        guard let text = textField.text else { return }
        
        self.delegate?.judoPayInput(self, isValid: text.characters.count == self.cardNetwork.securityCodeLength())
    }
    
    
    /**
     The placeholder string for the current input field
     
     - returns: An Attributed String that is the placeholder of the receiver
     */
    override public func placeholder() -> NSAttributedString? {
        return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
    }
    
    
    /**
     Boolean indicating whether the receiver has to show a logo
     
     - returns: True if input field shows a Logo
     */
    override public func containsLogo() -> Bool {
        return true
    }
    
    
    /**
     If the receiving input field contains a logo, this method returns Some
     
     - returns: An optional CardLogoView
     */
    override public func logoView() -> CardLogoView? {
        let type: CardLogoType = self.cardNetwork == .AMEX ? .CIDV : .CVC
        return CardLogoView(type: type)
    }
    
    
    /**
     Title of the receiver input field
     
     - returns: A string that is the title of the receiver
     */
    override public func title() -> String {
        return self.cardNetwork.securityCodeTitle()
    }
    
    
    /**
     Hint label text
     
     - returns: String that is shown as a hint when user resides in a input field for more than 5 seconds
     */
    override public func hintLabelText() -> String {
        if isTokenPayment {
            return "For security, please re-enter the card \(self.cardNetwork.securityCodeTitle())"
        }
        return "Security code"
    }

}
