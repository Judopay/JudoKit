//
//  JudoPayInputField.swift
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

public protocol JudoPayInputDelegate {
    func issueNumberInputDidEnterCode(inputField: IssueNumberInputField, issueNumber: String)
    
    func cardInput(input: CardInputField, error: ErrorType)
    func cardInput(input: CardInputField, didFindValidNumber cardNumberString: String)
    func cardInput(input: CardInputField, didDetectNetwork network: CardNetwork)
    
    func dateInput(input: DateInputField, error: ErrorType)
    func dateInput(input: DateInputField, didFindValidDate date: String)
    
    func judoPayInput(input: JudoPayInputField, isValid: Bool)
    
    func billingCountryInputDidEnter(input: BillingCountryInputField, billingCountry: BillingCountry)
}

public class JudoPayInputField: UIView, UITextFieldDelegate {

    let textField: UITextField = UITextField()
    
    let titleLabel: UILabel = UILabel()
    
    lazy var logoContainerView: UIView = UIView()
    
    public var delegate: JudoPayInputDelegate?
    
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
        self.backgroundColor = .whiteColor()
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.judoLightGrayColor().CGColor
        self.layer.borderWidth = 1.0
        
        self.titleLabel.text = self.title()

        self.textField.delegate = self
        self.textField.keyboardType = .NumberPad
        
        self.addSubview(self.textField)
        self.addSubview(self.titleLabel)
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title]|", options: .AlignAllBaseline, metrics: nil, views: ["title":titleLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[text]|", options: .AlignAllBaseline, metrics: nil, views: ["text":textField]))
        
        self.titleLabel.textColor = .judoDarkGrayColor()
        self.textField.textColor = .judoDarkGrayColor()
        
        self.titleLabel.font = UIFont.systemFontOfSize(14)
        self.textField.font = UIFont.boldSystemFontOfSize(14)
        
        self.textField.placeholder = self.placeholder()
        self.textField.addTarget(self, action: Selector("textFieldDidChangeValue:"), forControlEvents: .EditingChanged)
        
        var visualFormat = "|-12-[title(50)][text]-12-|"
        var views = ["title":titleLabel, "text":textField]
        if self.containsLogo() {
            let logoView = self.logoView()!
            logoView.frame = CGRectMake(0, 0, 38, 25)
            self.addSubview(self.logoContainerView)
            self.logoContainerView.translatesAutoresizingMaskIntoConstraints = false
            self.logoContainerView.clipsToBounds = true
            self.logoContainerView.layer.cornerRadius = 2
            self.logoContainerView.addSubview(logoView)
            
            visualFormat = "|-12-[title(50)][text][logo(38)]-12-|"
            views["logo"] = self.logoContainerView
            
            self.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            self.logoContainerView.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0))
        }
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: .DirectionLeftToRight, metrics: nil, views: views))
    }
    
    // MARK: Helpers
    
    public func errorAnimation() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 8, -8, 4, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.4
        animation.additive = true
        self.layer.addAnimation(animation, forKey: "wiggle")
    }
    
    public func updateCardLogo() {
        let logoView = self.logoView()!
        logoView.frame = CGRectMake(0, 0, 38, 25)
        if let oldLogoView = self.logoContainerView.subviews.first as? CardLogoView {
            if oldLogoView.type != logoView.type {
                UIView.transitionFromView(self.logoContainerView.subviews.first!, toView: logoView, duration: 0.3, options: .TransitionFlipFromBottom, completion: nil)
            }
        }
        self.textField.placeholder = self.placeholder()
    }
    
    // MARK: Custom methods
    
    func textFieldDidChangeValue(textField: UITextField) {
        // method for subclassing
    }
    
    func placeholder() -> String? {
        return nil
    }
    
    func containsLogo() -> Bool {
        return false
    }
    
    func logoView() -> CardLogoView? {
        return nil
    }
    
    func title() -> String {
        return ""
    }
    
}
