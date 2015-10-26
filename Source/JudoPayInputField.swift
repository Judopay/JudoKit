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

public enum LayoutType {
    case Aside, Above
    
    func autoLayout(containsLogo: Bool, titleWidth: Int) -> String {
        switch self {
        case .Aside where containsLogo:
            return "|-12-[title(\(titleWidth))][text][logo(38)]-12-|"
        case .Above where containsLogo:
            return "|-12-[text][logo(38)]-12-|"
        case .Aside where !containsLogo:
            return "|-12-[title(\(titleWidth))][text]-12-|"
        default: // .Above where !containsLogo:
            return "|-12-[text]-12-|"
        }
    }
}

public protocol JudoPayInputDelegate {
    func issueNumberInputDidEnterCode(inputField: IssueNumberInputField, issueNumber: String)
    
    func cardInput(input: CardInputField, error: JudoError)
    func cardInput(input: CardInputField, didFindValidNumber cardNumberString: String)
    func cardInput(input: CardInputField, didDetectNetwork network: CardNetwork)
    
    func dateInput(input: DateInputField, error: JudoError)
    func dateInput(input: DateInputField, didFindValidDate date: String)
    
    func judoPayInput(input: JudoPayInputField, isValid: Bool)
    
    func billingCountryInputDidEnter(input: BillingCountryInputField, billingCountry: BillingCountry)
    
    func judoPayInputDidChangeText(input: JudoPayInputField)
}

public class JudoPayInputField: UIView, UITextFieldDelegate {

    let floatingTextField: FloatingTextField = FloatingTextField()
    let asideTextField: UITextField = UITextField()
    
    let titleLabel: UILabel = UILabel()
    
    var layoutType: LayoutType = .Above
    
    lazy var logoContainerView: UIView = UIView()
    
    public var delegate: JudoPayInputDelegate?
    
    private let redBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.judoRedColor()
        return view
    }()
    
    // MARK: Initializers
    
    public init(layoutType: LayoutType) {
        self.layoutType = layoutType
        super.init(frame: CGRectZero)
        self.setupView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = .judoInputFieldBackgroundColor()
        self.clipsToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.judoLightGrayColor().CGColor
        self.layer.borderWidth = 1.0
        
        self.textField().delegate = self
        self.textField().keyboardType = .NumberPad
        
        self.addSubview(self.textField())
        self.addSubview(self.redBlock)
        
        self.textField().translatesAutoresizingMaskIntoConstraints = false
        self.textField().textColor = .judoDarkGrayColor()
        self.textField().tintColor = JudoKit.tintColor
        self.textField().font = UIFont.boldSystemFontOfSize(14)
        self.textField().addTarget(self, action: Selector("textFieldDidChangeValue:"), forControlEvents: .EditingChanged)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[text]|", options: .AlignAllBaseline, metrics: nil, views: ["text":textField()]))
        
        self.setActive(false)

        if self.layoutType == .Aside {
            self.titleLabel.text = self.title()
            self.addSubview(self.titleLabel)
            self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title]|", options: .AlignAllBaseline, metrics: nil, views: ["title":titleLabel]))
            self.titleLabel.textColor = .judoDarkGrayColor()
            self.titleLabel.font = UIFont.systemFontOfSize(14)
            self.textField().attributedPlaceholder = self.placeholder()
        } else {
            self.titleLabel.removeFromSuperview()
            self.textField().attributedPlaceholder = NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName: UIColor.judoLightGrayColor()])
        }
        
        if self.containsLogo() {
            let logoView = self.logoView()!
            logoView.frame = CGRectMake(0, 0, 38, 25)
            self.addSubview(self.logoContainerView)
            self.logoContainerView.translatesAutoresizingMaskIntoConstraints = false
            self.logoContainerView.clipsToBounds = true
            self.logoContainerView.layer.cornerRadius = 2
            self.logoContainerView.addSubview(logoView)
            
            self.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            self.logoContainerView.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0))
        }
        
        let visualFormat = self.layoutType.autoLayout(self.containsLogo(), titleWidth: self.titleWidth())
        let views: [String:UIView] = ["text": textField(), "title": self.titleLabel, "logo": self.logoContainerView]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: .DirectionLeftToRight, metrics: nil, views: views))
    }
    
    // MARK: Helpers
    
    public func errorAnimation(redBlock: Bool) {
        // animate the red block on the bottom
        
        let blockAnimation = { (didFinish: Bool) -> Void in
            let contentViewAnimation = CAKeyframeAnimation()
            contentViewAnimation.keyPath = "position.x"
            contentViewAnimation.values = [0, 10, -8, 6, -4, 2, 0]
            contentViewAnimation.keyTimes = [0, (1 / 11.0), (3 / 11.0), (5 / 11.0), (7 / 11.0), (9 / 11.0), 1]
            contentViewAnimation.duration = 0.4
            contentViewAnimation.additive = true
            
            self.layer.addAnimation(contentViewAnimation, forKey: "wiggle")
        }
        
        if redBlock {
            self.redBlock.frame = CGRectMake(0, self.bounds.height, self.bounds.width, 4.0)
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.redBlock.frame = CGRectMake(0, self.bounds.height - 4, self.bounds.width, 4.0)
                self.titleLabel.textColor = UIColor.judoRedColor()
                self.textField().textColor = UIColor.judoRedColor()
                }, completion: blockAnimation)
        } else {
            blockAnimation(true)
        }
    }
    
    public func updateCardLogo() {
        let logoView = self.logoView()!
        logoView.frame = CGRectMake(0, 0, 38, 25)
        if let oldLogoView = self.logoContainerView.subviews.first as? CardLogoView {
            if oldLogoView.type != logoView.type {
                UIView.transitionFromView(self.logoContainerView.subviews.first!, toView: logoView, duration: 0.3, options: .TransitionFlipFromBottom, completion: nil)
            }
        }
        self.textField().attributedPlaceholder = self.placeholder()
    }
    
    public func setActive(isActive: Bool) {
        self.textField().alpha = isActive ? 1.0 : 0.5
        self.titleLabel.alpha = isActive ? 1.0 : 0.5
    }
    
    public func dismissError() {
        if self.redBlock.bounds.size.height > 0 {
            UIView.animateWithDuration(0.4) { () -> Void in
                self.redBlock.frame = CGRectMake(0.0, self.bounds.height, self.bounds.width, 4.0)
                self.titleLabel.textColor = .judoDarkGrayColor()
                self.textField().textColor = .judoDarkGrayColor()
            }
        }
    }
    
    public func textFieldDidBeginEditing(textField: UITextField) {
        self.setActive(true)
    }
    
    public func textFieldDidEndEditing(textField: UITextField) {
        self.setActive(textField.text?.characters.count > 0)
    }
    
    public func textField() -> UITextField {
        if self.layoutType == .Aside {
            return self.asideTextField
        }
        return self.floatingTextField
    }
    
    // MARK: Custom methods
    
    func didChangeInputText() {
        self.delegate?.judoPayInputDidChangeText(self)
    }
    
    func textFieldDidChangeValue(textField: UITextField) {
        self.dismissError()
        // method for subclassing
    }
    
    func placeholder() -> NSAttributedString? {
        if self.layoutType == .Above {
            return nil
        }
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
    
    func titleWidth() -> Int {
        return 50
    }
    
    func hintLabelText() -> String {
        return ""
    }
    
}
