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

let inputFieldBorderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)

public class JPayViewController: UIViewController, CardTextFieldDelegate, DateTextFieldDelegate {
    
    public static func payment() -> UINavigationController {
        return UINavigationController(rootViewController: JPayViewController())
    }
    
    let cardTextField: CardTextField = {
        let inputField = CardTextField()
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.layer.borderColor = inputFieldBorderColor.CGColor
        inputField.layer.borderWidth = 1.0
        return inputField
    }()
    
    let expiryDateTextField: DateTextField = {
        let inputField = DateTextField()
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.layer.borderColor = inputFieldBorderColor.CGColor
        inputField.layer.borderWidth = 1.0
        return inputField
    }()
    
    let secureCodeTextField: SecurityTextField = {
        let inputField = SecurityTextField()
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.layer.borderColor = inputFieldBorderColor.CGColor
        inputField.layer.borderWidth = 1.0
        return inputField
    }()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(cardTextField)
        self.view.addSubview(expiryDateTextField)
        self.view.addSubview(secureCodeTextField)
        
        self.cardTextField.delegate = self
        self.expiryDateTextField.delegate = self
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(-1)-[card]-(-1)-|", options: .AlignAllBaseline, metrics: nil, views: ["card":self.cardTextField]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-(-1)-[expiry]-(-1)-[security(==expiry)]-(-1)-|", options: .AlignAllBaseline, metrics: nil, views: ["expiry":self.expiryDateTextField, "security":self.secureCodeTextField]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[card(44)]-(-1)-[expiry(44)]->=20-|", options: .AlignAllLeft, metrics: nil, views: ["card":self.cardTextField, "expiry":self.expiryDateTextField]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-79-[card(44)]-(-1)-[security(44)]->=20-|", options: .AlignAllRight, metrics: nil, views: ["card":self.cardTextField, "security":self.secureCodeTextField]))
    }
    
    func errorAnimation(view: JudoPayInputField) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 8, -8, 4, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.4
        animation.additive = true
        view.layer.addAnimation(animation, forKey: "wiggle")
    }
    
    // MARK: CardTextFieldDelegate
    
    public func cardTextField(textField: CardTextField, error: ErrorType) {
        self.errorAnimation(textField)
    }
    
    public func cardTextField(textField: CardTextField, didFindValidNumber cardNumberString: String) {
        self.expiryDateTextField.textField.becomeFirstResponder()
    }
    
    public func cardTextField(textField: CardTextField, didDetectNetwork network: CardNetwork) {
        self.cardTextField.updateCardLogo()
        self.secureCodeTextField.cardNetwork = network
        self.secureCodeTextField.updateCardLogo()
        self.secureCodeTextField.titleLabel.text = network.securityCodeTitle()
    }
    
    // MARK: DateTextFieldDelegate
    
    public func dateTextField(textField: DateTextField, error: ErrorType) {
        self.errorAnimation(textField)
    }
    
    public func dateTextField(textField: DateTextField, didFindValidDate date: String) {
        self.secureCodeTextField.textField.becomeFirstResponder()
    }
    
    
}
