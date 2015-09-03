//
//  Payment.swift
//  Judo
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

public protocol CardTextFieldDelegate {
    func cardTextField(textField: CardTextField, error: ErrorType)
    func cardTextField(textField: CardTextField, didFindValidNumber cardNumberString: String)
    func cardTextField(textField: CardTextField, didDetectNetwork: CardNetwork)
}

public class CardTextField: JudoPayInputField {
    
    public var acceptedCardNetworks: [Card.Configuration]?
    
    public var delegate: CardTextFieldDelegate?
    
    
    // MARK: UITextFieldDelegate
    
    @objc public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // only handle delegate calls for own textfield
        guard textField == self.textField else { return true }
        
        // get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            return true
        }
        
        do {
            textField.text = try newString.cardPresentationString(self.acceptedCardNetworks)
            self.delegate?.cardTextField(self, didDetectNetwork: textField.text!.cardNetwork())
        } catch let error {
            self.delegate?.cardTextField(self, error: error)
        }
        
        if textField.text!.characters.count > Card.minimumLength {
            if textField.text!.isCardNumberValid() {
                self.delegate?.cardTextField(self, didFindValidNumber: textField.text!)
            } else {
                self.delegate?.cardTextField(self, error: JudoError.InvalidCardNumber)
            }
        }
        
        return false
        
    }
    
}
