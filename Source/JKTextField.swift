//
//  JKTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 13/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

class JKTextField: UIScrollView, UITextFieldDelegate {
    
    let textField: UITextField = UITextField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        textField.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        textField.delegate = self
    }
    
    // MARK: UITextFieldDelegate
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        switch newString.characters.count {
        case 0:
            return true
        default:
            break
        }
        
        var regex: NSRegularExpression?
        
        let pattern = "\\d{4}"
        
//        let pattern = "^(?:4[0-9]{12}(?:[0-9]{3})? | 5[1-5][0-9]{14} | 3[47][0-9]{13} | 3(?:0[0-5]|[68][0-9])[0-9]{11} | 6(?:011|5[0-9]{2})[0-9]{12} | (?:2131|1800|35\\d{3})\\d{11})$"
        
        do {
            regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
        } catch {
            return false
        }
        
        let numberOfMatches = regex!.numberOfMatchesInString(newString, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, newString.characters.count))
        
        return numberOfMatches > 0
    }
    
}
