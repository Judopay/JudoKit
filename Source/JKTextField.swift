//
//  JKTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 13/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

public class JKTextField: UIScrollView, UITextFieldDelegate {
    
    let textField: UITextField = UITextField()
    
    init() {
        super.init(frame: CGRectMake(0, 0, 300, 44))
        self.textField.frame = frame
        self.textField.delegate = self
        self.addSubview(self.textField)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, 300, 44))
        self.textField.frame = frame
        self.textField.delegate = self
        self.addSubview(self.textField)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textField.frame = frame
        self.textField.delegate = self
        self.addSubview(self.textField)
    }
    
    // MARK: UITextFieldDelegate
    
    // FIXME: this needs fixing!
    @objc public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        let beginning = textField.beginningOfDocument
        let start = textField.positionFromPosition(beginning, offset: range.location)
        let end = textField.positionFromPosition(start!, offset:range.length)
        let textRange = textField.textRangeFromPosition(start!, toPosition:end!)
        
        let currentCursorPosition = textField.positionFromPosition(textField.beginningOfDocument, offset: 0)
        // this will be the new cursor location after insert/paste/typing
        let cursorOffset = textField.offsetFromPosition(beginning, toPosition:start!) + string.characters.count
        
        textField.replaceRange(textRange!, withText: string)

        do {
            textField.text = try newString.cardPresentationString()
        } catch {
            // do nothing
        }
        
        
        let newCursorPosition = textField.positionFromPosition(textField.beginningOfDocument, offset:cursorOffset)
        let newSelectedRange = textField.textRangeFromPosition(newCursorPosition!, toPosition:newCursorPosition!)
        textField.selectedTextRange = newSelectedRange
        
//        if let currentCursorPosition = currentCursorPosition {
//            if let newCursorPosition = textField.positionFromPosition(currentCursorPosition, offset: 1) {
//                let newRange = textField.textRangeFromPosition(newCursorPosition, toPosition: newCursorPosition)
//                textField.selectedTextRange = newRange
//            }
//        }
        
        
        return false
    }
    
}
