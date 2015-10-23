//
//  Payment.swift
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

public class CardInputField: JudoPayInputField {
    
    public var acceptedCardNetworks: [Card.Configuration]?
    
    // MARK: UITextFieldDelegate
    
    @objc public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        // only handle delegate calls for own textfield
        guard textField == self.textField() else { return false }
        
        // get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            return true
        }
        
        do {
            textField.text = try newString.cardPresentationString(self.acceptedCardNetworks)
            self.delegate?.cardInput(self, didDetectNetwork: textField.text!.cardNetwork())
            self.dismissError()
        } catch let error {
            self.delegate?.cardInput(self, error: error as! JudoError)
        }
        
        var cardConfigs = defaultCardConfigurations
        
        if let acceptedCardConfigs = self.acceptedCardNetworks {
            cardConfigs = acceptedCardConfigs
        }
        
        let filteredNetworks = cardConfigs.filter { $0.cardNetwork == newString.cardNetwork()}
        
        let lowestNumber = filteredNetworks.sort { $0.cardLength < $1.cardLength }
        
        if let textCount = textField.text?.stripped.characters.count where textCount == lowestNumber.first?.cardLength {
            if textField.text!.isCardNumberValid() {
                self.delegate?.cardInput(self, didFindValidNumber: textField.text!)
                self.dismissError()
            } else {
                self.delegate?.cardInput(self, error: JudoError.InvalidCardNumber)
            }
        }
        
        return false
        
    }
    
    // MARK: Custom methods
    
    override func placeholder() -> NSAttributedString? {
        if self.layoutType == .Above {
            return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
        }
        if let acceptedCardNetworks = self.acceptedCardNetworks {
            return NSAttributedString(string: acceptedCardNetworks.first?.placeholderString() ?? "", attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
        } else {
            return NSAttributedString(string: defaultCardConfigurations.first?.placeholderString() ?? "", attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
        }
    }
    
    override func containsLogo() -> Bool {
        return true
    }
    
    override func logoView() -> CardLogoView? {
        var type: CardLogoType = .Unknown
        switch self.textField().text!.cardNetwork() {
        case .Visa(.Credit), .Visa(.Debit), .Visa(.Unknown):
            type = .Visa
        case .MasterCard(.Credit), .MasterCard(.Debit), .MasterCard(.Unknown):
            type = .MasterCard
        case .Maestro:
            type = .Maestro
        case .AMEX:
            type = .AMEX
        default:
            break
        }
        return CardLogoView(type: type)
    }
    
    override func title() -> String {
        if self.layoutType == .Above {
            return "Card number"
        }
        return "Card"
    }
    
    override func hintLabelText() -> String {
        return "Enter Your Credit Card number"
    }

}
