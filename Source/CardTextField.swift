//
//  JKTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 13/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo

public protocol CardTextFieldDelegate {
    func cardTextField(textField: CardTextField, error: ErrorType)
    func cardTextField(textField: CardTextField, didFindValidNumber cardNumberString: String)
    func cardTextField(textField: CardTextField, didDetectNetwork: CardNetwork)
}

public class CardTextField: UIView, UITextFieldDelegate {
    
    let textField: UITextField = UITextField()
    
    public var acceptedCardNetworks: [Card.Configuration]?
    
    public var delegate: CardTextFieldDelegate?
    
    // MARK: Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.textField.frame = self.frame
        self.textField.delegate = self
        self.addSubview(self.textField)
    }
    
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
