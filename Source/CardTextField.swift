//
//  JKTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 13/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo

protocol CardTextFieldDelegate {
    func cardTextField(textField: CardTextField, didFinishEnteringNumber cardNumberString: String, ofCardNetwork cardNetwork: CardNetwork)
}

public class CardTextField: UIView, UITextFieldDelegate {
    
    let textField: UITextField = UITextField()
    
    var acceptedCardNetworks: [CardNetwork]?
    
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
        
        guard textField == self.textField else { return true }
        
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            self.backgroundColor = UIColor.clearColor()
            return true
        }
        
        do {
            textField.text = try newString.cardPresentationString()
        } catch {
            self.backgroundColor = UIColor.redColor()
            // visual representation of false input
        }
        
        if textField.text!.isCardNumberValid() {
            self.backgroundColor = UIColor.greenColor()
        } else {
            self.backgroundColor = UIColor.redColor()
        }
        
        return false
        
    }
    
}
