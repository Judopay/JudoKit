//
//  IssueNumberInputField.swift
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

public class IssueNumberInputField: JudoPayInputField {
    
    // MARK: UITextFieldDelegate Methods
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // only handle delegate calls for own textfield
        guard textField == self.textField() else { return false }
        
        // get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            return true
        }
        
        return newString.isNumeric() && newString.characters.count <= 3
    }
    
    // MARK: Custom methods
    
    override func textFieldDidChangeValue(textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        guard let text = textField.text else { return }
        
        self.delegate?.issueNumberInputDidEnterCode(self, issueNumber: text)
    }

    override func placeholder() -> NSAttributedString? {
        if self.layoutType == .Above {
            return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
        }
        return NSAttributedString(string: "00", attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
    }
    
    override func title() -> String {
        if self.layoutType == .Above {
            return "Issue number"
        }
        return "Issue"
    }
    
    override func hintLabelText() -> String {
        return "Issue number on front of card"
    }

}
