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
    let identifyLabel: UILabel = {
        let label = UILabel(frame: CGRectMake(220, 0, 80, 44))
        label.font = UIFont.systemFontOfSize(10)
        return label
        }()
    
    init() {
        super.init(frame: CGRectMake(0, 0, 300, 44))
        self.textField.frame = frame
        self.textField.delegate = self
        self.addSubview(self.textField)
        self.addSubview(self.identifyLabel)
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRectMake(0, 0, 300, 44))
        self.textField.frame = frame
        self.textField.delegate = self
        self.addSubview(self.textField)
        self.addSubview(self.identifyLabel)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.textField.frame = frame
        self.textField.delegate = self
        self.addSubview(self.textField)
        self.addSubview(self.identifyLabel)
    }
    
    // MARK: UITextFieldDelegate
    
    @objc public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            textField.backgroundColor = UIColor.grayColor()
            self.identifyLabel.text = ""
            return true
        }
        
        do {
            textField.text = try newString.cardPresentationString()
        } catch {
            textField.backgroundColor = UIColor.redColor()
            // visual representation of false input
        }
        
        if textField.text!.isCardNumberValid() {
            textField.backgroundColor = UIColor.greenColor()
        } else {
            textField.backgroundColor = UIColor.redColor()
        }
        
        self.identifyLabel.text = textField.text!.cardNetwork().stringValue()

        return false
    }
    
}
