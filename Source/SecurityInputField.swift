//
//  SecurityTextField.swift
//  JudoKit
//
//  Copyright (c) 2015 Alternative Payments Ltd
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

public protocol SecurityTextFieldDelegate {
    func securityTextFieldDidEnterCode(textField: SecurityInputField, isValid: Bool)
}

public class SecurityInputField: JudoPayInputField {
    
    public var cardNetwork: CardNetwork = .Unknown
    
    public var delegate: SecurityTextFieldDelegate?
    
    // MARK: UITextFieldDelegate Methods
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // only handle delegate calls for own textfield
        guard textField == self.textField else { return false }
        
        // get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            return true
        }
        
        return newString.isNumeric() && newString.characters.count <= self.cardNetwork.securityCodeLength()
    }
    
    // MARK: Custom methods
    
    override func textFieldDidChangeValue(textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.delegate?.securityTextFieldDidEnterCode(self, isValid: text.characters.count == self.cardNetwork.securityCodeLength())
    }
    
    override func placeholder() -> String? {
        if self.cardNetwork == .AMEX {
            return "0000"
        } else {
            return "000"
        }
    }
    
    override func containsLogo() -> Bool {
        return true
    }
    
    override func logoView() -> CardLogoView? {
        let type: CardLogoType = self.cardNetwork == .AMEX ? .CIDV : .CVC
        return CardLogoView(type: type)
    }
    
    override func title() -> String {
        return self.cardNetwork.securityCodeTitle()
    }

}
