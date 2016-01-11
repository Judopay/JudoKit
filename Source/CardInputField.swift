//
//  CardInputField.swift
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
 
 The CardInputField is an input field configured to detect, validate and present card numbers of various types of credit cards.
 
 */
public class CardInputField: JudoPayInputField {
    
    public var cardNetwork: CardNetwork = .Unknown
    
    // MARK: UITextFieldDelegate
    
    @objc public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // only handle delegate calls for own textfield
        guard textField == self.textField else { return false }
        
        // get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 || string.characters.count == 0 {
            return true
        }
        
        var result: String?
        
        do {
            result = try self.textField.text?.cardPresentationString(JudoKit.acceptedCardNetworks)
            self.dismissError()
        } catch let error {
            self.delegate?.cardInput(self, error: error as! JudoError)
        }
        
        if result == nil {
            return false
        }
        
        self.didChangeInputText()
        
        return true
        
    }
    
    // MARK: Custom methods
    
    override public func isValid() -> Bool {
        return self.textField.text?.isCardNumberValid() ?? false
    }
    
    override public func textFieldDidChangeValue(textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        
        do {
            self.textField.text = try self.textField.text?.cardPresentationString(JudoKit.acceptedCardNetworks)
            self.delegate?.cardInput(self, didDetectNetwork: textField.text!.cardNetwork())
            self.dismissError()
        } catch let error {
            self.delegate?.cardInput(self, error: error as! JudoError)
        }
        
        let lowestNumber = JudoKit.acceptedCardNetworks.filter({ $0.cardNetwork == self.textField.text?.cardNetwork() }).sort(<)
        
        if let textCount = textField.text?.stripped.characters.count where textCount == lowestNumber.first?.cardLength {
            if textField.text!.isCardNumberValid() {
                self.delegate?.cardInput(self, didFindValidNumber: textField.text!)
                self.dismissError()
            } else {
                self.delegate?.cardInput(self, error: JudoError(.InvalidCardNumber, "the card number is invalid"))
            }
        }

    }
    
    override public func placeholder() -> NSAttributedString? {
        return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
    }
    
    override public func containsLogo() -> Bool {
        return true
    }
    
    override public func logoView() -> CardLogoView? {
        return CardLogoView(type: self.cardNetwork.cardLogoType())
    }
    
    override public func title() -> String {
        return "Card number"
    }
    
    override public func hintLabelText() -> String {
        return "Long card number"
    }

}
