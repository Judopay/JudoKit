//
//  CardNameField.swift
//  JudoKit
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

import UIKit

open class CardNameField : JudoPayInputField {
    
    override func setupView() {
        self.textField.isSecureTextEntry = false
        super.setupView()
        self.textField.keyboardType = .default
    }
    
    // MARK: UITextFieldDelegate
    
    /**
     Subclassed method that is called when textField content was changed
     
     - parameter textField: the textfield of which the content has changed
     */
    open override func textFieldDidChangeValue(_ textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        
        self.didChangeInputText()
    }
    
    /**
     The placeholder string for the current cardNameField
     
     - returns: an Attributed String that is the placeholder of the receiver
     */
    open override func placeholder() -> NSAttributedString? {
        return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:self.theme.getPlaceholderTextColor()])
    }
    
    /**
     Title of the receiver cardNameField
     
     - returns: a string that is the title of the receiver
     */
    open override func title() -> String {
        return "Name this card (optional)"
    }
    
    
    /**
     Hint label text
     
     - returns: string that is shown as a hint when user resides in a inputField for more than 5 seconds
     */
    open override func hintLabelText() -> String {
        return "Name this card"
    }

}
