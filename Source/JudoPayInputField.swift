//
//  JudoPayInputField.swift
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


/**
 
 The JudoPayInputField is a UIView subclass that is used to help to validate and visualize common information related to payments. This class delivers the common ground for the UI and UX. Text fields can either be used in a side-by-side motion (title on the left and input text field on the right) or with a floating title that floats to the top as soon as a user starts entering their details.
 
 It is not recommended to use this class directly but rather use the subclasses of JudoPayInputField that are also provided in judoKit as this class does not do any validation which are necessary for making any kind of transaction.
 
 */
@objc public class JudoPayInputField: UIView, UITextFieldDelegate, ErrorAnimatable {
    
    /// The delegate for the input field validation methods
    public var delegate: JudoPayInputDelegate?
    
    /// the theme of the current judoKit session
    public var theme: Theme
    
    internal final let textField: FloatingTextField = FloatingTextField()
    
    internal lazy var logoContainerView: UIView = UIView()
    
    let redBlock = UIView()
    
    // MARK: Initializers
    
    /**
     Designated Initializer for JudoPayInputField
     
     - parameter theme: the theme to use
     
     - returns: a JudoPayInputField instance
     */
    public init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRectZero)
        self.setupView()
    }
    
    
    /**
     Designated Initializer for JudoPayInputField
     
     - parameter frame: the frame of the input view
     
     - returns: a JudoPayInputField instance
     */
    override public init(frame: CGRect) {
        self.theme = Theme()
        super.init(frame: CGRectZero)
        self.setupView()
    }
    
    
    /**
     Required initializer set as convenience to trigger the designated initializer that contains all necessary initialization methods
     
     - parameter aDecoder: decoder is ignored
     
     - returns: a JudoPayInputField instance
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    
    /**
     Helper method to initialize the view
     */
    func setupView() {
        self.redBlock.backgroundColor = self.theme.getErrorColor()

        self.backgroundColor = self.theme.getInputFieldBackgroundColor()
        self.clipsToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = self.theme.getInputFieldBorderColor().CGColor
        self.layer.borderWidth = 0.5
        
        self.textField.delegate = self
        self.textField.keyboardType = .NumberPad
        
        self.addSubview(self.textField)
        self.addSubview(self.redBlock)
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.textColor = self.theme.getInputFieldTextColor()
        self.textField.tintColor = self.theme.tintColor
        self.textField.font = UIFont.boldSystemFontOfSize(14)
        self.textField.addTarget(self, action: #selector(JudoInputType.textFieldDidChangeValue(_:)), forControlEvents: .EditingChanged)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[text]|", options: .AlignAllBaseline, metrics: nil, views: ["text":textField]))
        
        self.setActive(false)
        
        self.textField.attributedPlaceholder = NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName: self.theme.getPlaceholderTextColor()])
        
        if self.containsLogo() {
            let logoView = self.logoView()!
            logoView.frame = CGRectMake(0, 0, 42, 27)
            self.addSubview(self.logoContainerView)
            self.logoContainerView.translatesAutoresizingMaskIntoConstraints = false
            self.logoContainerView.clipsToBounds = true
            self.logoContainerView.layer.cornerRadius = 2
            self.logoContainerView.addSubview(logoView)
            
            self.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            self.logoContainerView.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 27.0))
        }
        
        let visualFormat = self.containsLogo() ? "|-13-[text][logo(42)]-13-|" : "|-13-[text]-13-|"
        let views: [String:UIView] = ["text": textField, "logo": self.logoContainerView]
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: .DirectionLeftToRight, metrics: nil, views: views))
    }
    
    // MARK: Helpers
    
    
    /**
     In the case of an updated card logo, this method animates the change
     */
    public func updateCardLogo() {
        let logoView = self.logoView()!
        logoView.frame = CGRectMake(0, 0, 42, 27)
        if let oldLogoView = self.logoContainerView.subviews.first as? CardLogoView {
            if oldLogoView.type != logoView.type {
                UIView.transitionFromView(self.logoContainerView.subviews.first!, toView: logoView, duration: 0.3, options: .TransitionFlipFromBottom, completion: nil)
            }
        }
        self.textField.attributedPlaceholder = self.placeholder()
    }
    
    
    /**
     Set current object as active text field visually
     
     - parameter isActive: Boolean stating whether textfield has become active or inactive
     */
    public func setActive(isActive: Bool) {
        self.textField.alpha = isActive ? 1.0 : 0.5
        self.logoContainerView.alpha = isActive ? 1.0 : 0.5
    }
    
    
    /**
     Method that dismisses the error generated in the `errorAnmiation:` method
     */
    public func dismissError() {
        if self.redBlock.bounds.size.height > 0 {
            UIView.animateWithDuration(0.4) { () -> Void in
                self.redBlock.frame = CGRectMake(0.0, self.bounds.height, self.bounds.width, 4.0)
                self.textField.textColor = self.theme.getTextColor()
            }
        }
    }
    
    
    /**
     Delegate method when text field did begin editing
     
     - parameter textField: The `UITextField` that has begun editing
     */
    public func textFieldDidBeginEditing(textField: UITextField) {
        self.setActive(true)
        self.delegate?.judoPayInputDidChangeText(self)
    }
    
    /**
     Delegate method when text field did end editing
     
     - parameter textField: the `UITextField` that has ended editing
     */
    public func textFieldDidEndEditing(textField: UITextField) {
        self.setActive(textField.text?.characters.count > 0)
    }
    
}

public extension JudoPayInputField: JudoInputType { }

