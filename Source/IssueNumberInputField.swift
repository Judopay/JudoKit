//
//  IssueNumberInputField.swift
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
 
 The IssueNumberInputField is an input field configured to detect, validate and present issue numbers for Maestro cards.
 
 */
public class IssueNumberInputField: JudoPayInputField {
    
    // MARK: UITextFieldDelegate Methods
    
    
    /**
    Delegate method implementation
    
    - parameter textField: Text field
    - parameter range:     Range
    - parameter string:    String
    
    - returns: boolean to change characters in given range for a textfield
    */
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // Only handle delegate calls for own textfield
        guard textField == self.textField else { return false }
        
        // Get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            return true
        }
        
        return newString.isNumeric() && newString.characters.count <= 3
    }
    
    // MARK: Custom methods
    
    
    /**
    Check if this input field is valid
    
    - returns: True if valid input
    */
    override public func isValid() -> Bool {
        return self.textField.text?.characters.count > 0 && self.textField.text?.characters.count < 4
    }
    
    
    /**
     Subclassed method that is called when text field content was changed
     
     - parameter textField: the textfield of which the content has changed
     */
    override public func textFieldDidChangeValue(textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        
        self.didChangeInputText()
        
        guard let text = textField.text else { return }
        
        self.delegate?.issueNumberInputDidEnterCode(self, issueNumber: text)
    }
    
    
    /**
     The placeholder string for the current input field
     
     - returns: an Attributed String that is the placeholder of the receiver
     */
    override public func placeholder() -> NSAttributedString? {
        return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:self.theme.getPlaceholderTextColor()])
    }
    
    
    /**
     Title of the receiver input field
     
     - returns: a string that is the title of the receiver
     */
    override public func title() -> String {
        return "Issue number"
    }
    
    
    /**
     Hint label text
     
     - returns: string that is shown as a hint when user resides in a inputField for more than 5 seconds
     */
    override public func hintLabelText() -> String {
        return "Issue number on front of card"
    }

}
