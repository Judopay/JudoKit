//
//  JKTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 13/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo

public class JKTextField: UIScrollView, UITextFieldDelegate {
    
    let cardNumberTextField: UITextField = UITextField()
    let expiryDateTextField: UITextField = UITextField()
    let ccvTextField: UITextField = UITextField()
    
    var acceptedCardNetworks: [CardNetwork]?
    
    let identifyLabel: UILabel = {
        let label = UILabel(frame: CGRectMake(200, 0, 40, 44))
        label.font = UIFont.systemFontOfSize(10)
        return label
        }()
    
    // MARK: Initializers
    
    init() {
        super.init(frame: CGRectMake(0, 0, 240, 44))
        self.setupView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, 240, 44))
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.frame = CGRectMake(0, 0, 240, 44)
        self.setupView()
    }
    
    func setupView() {
        self.contentSize = CGSizeMake(360, 44)
        
        self.cardNumberTextField.frame = CGRectMake(10, 0, 220, 44)
        self.cardNumberTextField.delegate = self
        self.addSubview(self.cardNumberTextField)
        
        self.expiryDateTextField.frame = CGRectMake(240, 0, 60, 44)
        self.expiryDateTextField.delegate = self
        self.addSubview(self.expiryDateTextField)
        
        self.ccvTextField.frame = CGRectMake(300, 0, 60, 44)
        self.ccvTextField.delegate = self
        self.addSubview(self.ccvTextField)
        
        self.addSubview(self.identifyLabel)
        
        self.showsVerticalScrollIndicator = false
    }
    
    // MARK: UITextFieldDelegate
    
    @objc public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == self.cardNumberTextField {
            let oldString = textField.text!
            let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
            
            if newString.characters.count == 0 {
                self.backgroundColor = UIColor.clearColor()
                self.identifyLabel.text = ""
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
                self.scrollRectToVisible(CGRectMake(180, 0, self.bounds.width, self.bounds.height), animated: true)
            } else {
                self.backgroundColor = UIColor.redColor()
                self.scrollRectToVisible(CGRectMake(0, 0, self.bounds.width, self.bounds.height), animated: true)
            }
            
            self.identifyLabel.text = textField.text!.cardNetwork().stringValue()
            
            return false
        }
        
        if textField == self.expiryDateTextField {
            
        }
        
        if textField == self.ccvTextField {
            
        }
        
        return true
        
    }
    
}
