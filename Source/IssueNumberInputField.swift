//
//  IssueNumberInputField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 09/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

public protocol IssueNumberInputDelegate {
    func issueNumberInputDidEnterCode(inputField: IssueNumberInputField, issueNumber: String)
}

public class IssueNumberInputField: JudoPayInputField {
    
    var delegate: IssueNumberInputDelegate?
    
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
        
        return newString.isNumeric() && newString.characters.count <= 3
    }
    
    // MARK: Custom methods
    
    override func textFieldDidChangeValue(textField: UITextField) {
        guard let text = textField.text else { return }
        
        self.delegate?.issueNumberInputDidEnterCode(self, issueNumber: text)
    }

    override func placeholder() -> String? {
        return "00"
    }
    
    override func title() -> String {
        return "Issue"
    }
    
}
