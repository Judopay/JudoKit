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

fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l < r
    case (nil, _?):
        return true
    default:
        return false
    }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
    switch (lhs, rhs) {
    case let (l?, r?):
        return l > r
    default:
        return rhs < lhs
    }
}

/**
 
 The JudoPayInputField is a UIView subclass that is used to help to validate and visualize common information related to payments. This class delivers the common ground for the UI and UX. Text fields can either be used in a side-by-side motion (title on the left and input text field on the right) or with a floating title that floats to the top as soon as a user starts entering their details.
 
 It is not recommended to use this class directly but rather use the subclasses of JudoPayInputField that are also provided in judoKit as this class does not do any validation which are necessary for making any kind of transaction.
 
 */
open class JudoPayInputField: UIView, UITextFieldDelegate, ErrorAnimatable {
    
    /// The delegate for the input field validation methods
    open var delegate: JudoPayInputDelegate?
    
    /// the theme of the current judoKit session
    open var theme: Theme
    
    internal final let textField: FloatingTextField = FloatingTextField()
    
    internal lazy var logoContainerView: UIView = UIView()
    
    let redBlock = UIView()
    
    let hintLabel = UILabel()
    var hasRedBlockBeenLaiedout = false
    
    var heightConstraint: NSLayoutConstraint!
    
    // MARK: Initializers
    
    /**
     Designated Initializer for JudoPayInputField
     
     - parameter theme: the theme to use
     
     - returns: a JudoPayInputField instance
     */
    public init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        self.setupView()
    }
    
    
    /**
     Designated Initializer for JudoPayInputField
     
     - parameter frame: the frame of the input view
     
     - returns: a JudoPayInputField instance
     */
    override public init(frame: CGRect) {
        self.theme = Theme()
        super.init(frame: CGRect.zero)
        self.setupView()
    }
    
    
    /**
     Required initializer set as convenience to trigger the designated initializer that contains all necessary initialization methods
     
     - parameter aDecoder: decoder is ignored
     
     - returns: a JudoPayInputField instance
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
    }
    
    override open func layoutSubviews() {
        if !self.hasRedBlockBeenLaiedout && self.frame.size.height == self.theme.inputFieldHeight {
            super.layoutSubviews()
            self.redBlockAsUnactive()
            self.hasRedBlockBeenLaiedout = true
        }
    }
    
    /**
     Helper method to initialize the view
     */
    func setupView() {
        self.redBlock.backgroundColor = self.theme.getErrorColor()
        self.redBlock.autoresizingMask = .flexibleWidth
        
        self.backgroundColor = self.theme.getInputFieldBackgroundColor()
        self.clipsToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.textField.delegate = self
        self.textField.keyboardType = .numberPad
        self.textField.keepBaseline = true
        self.textField.titleYPadding = 0.0
        
        self.addSubview(self.textField)
        self.addSubview(self.redBlock)
        
        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false
        self.hintLabel.font = UIFont.systemFont(ofSize: 12)
        self.addSubview(self.hintLabel)
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.textColor = self.theme.getInputFieldTextColor()
        self.textField.tintColor = self.theme.tintColor
        self.textField.font = UIFont.boldSystemFont(ofSize: 16)
        self.textField.addTarget(self, action: #selector(JudoInputType.textFieldDidChangeValue(_:)), for: .editingChanged)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[text(40)]", options: .alignAllLastBaseline, metrics: nil, views: ["text":textField]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[hintLabel]|", options: .alignAllLastBaseline, metrics: nil, views: ["hintLabel":hintLabel]))
        
        
        let height = self.isKind(of: BillingCountryInputField.self) || self.isKind(of: PostCodeInputField.self) ? 0.0 : self.theme.inputFieldHeight
        self.heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        if !self.isKind(of: SecurityInputField.self) && !self.isKind(of: IssueNumberInputField.self){
            self.addConstraint(heightConstraint)
        }
        self.setActive(false)
        
        self.textField.attributedPlaceholder = NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName: self.theme.getPlaceholderTextColor()])
        
        if self.containsLogo() {
            let logoView = self.logoView()!
            logoView.frame = CGRect(x: 0, y: 0, width: 46, height: 30)
            self.addSubview(self.logoContainerView)
            self.logoContainerView.translatesAutoresizingMaskIntoConstraints = false
            self.logoContainerView.clipsToBounds = true
            self.logoContainerView.layer.cornerRadius = 2
            self.logoContainerView.addSubview(logoView)
            
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(3.5)-[logo(30)]", options: .alignAllLastBaseline, metrics: nil, views: ["logo":self.logoContainerView]))
            
            self.logoContainerView.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30.0))
        }
        
        let visualFormat = self.containsLogo() ? "|-13-[text][logo(46)]-13-|" : "|-13-[text]-13-|"
        let views: [String:UIView] = ["text": textField, "logo": self.logoContainerView]
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: .directionLeftToRight, metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-13-[hintLabel]-13-|", options: .directionLeftToRight, metrics: nil, views: ["hintLabel":self.hintLabel]))
    }
    
    // MARK: Helpers
    
    /**
     In the case of an updated card logo, this method animates the change
     */
    open func updateCardLogo() {
        let logoView = self.logoView()!
        logoView.frame = CGRect(x: 0, y: 0, width: 46, height: 30)
        if let oldLogoView = self.logoContainerView.subviews.first as? CardLogoView {
            if oldLogoView.type != logoView.type {
                UIView.transition(from: self.logoContainerView.subviews.first!, to: logoView, duration: 0.3, options: .transitionFlipFromBottom, completion: nil)
            }
        }
        self.textField.attributedPlaceholder = self.placeholder()
    }
    
    
    /**
     Set current object as active text field visually
     
     - parameter isActive: Boolean stating whether textfield has become active or inactive
     */
    open func setActive(_ isActive: Bool) {
        self.textField.alpha = isActive ? 1.0 : 0.5
        self.logoContainerView.alpha = isActive ? 1.0 : 0.5
        self.hintLabel.text = ""
        
        if isActive {
            self.redBlockAsActive()
        }
        else {
            self.redBlockAsUnactive()
        }
    }
    
    
    /**
     Method that dismisses the error generated in the `errorAnmiation:` method
     */
    open func dismissError() {
        if self.theme.getErrorColor().isEqual(self.redBlock.backgroundColor) {
            self.setActive(true)
            self.hintLabel.textColor = self.theme.getInputFieldHintTextColor()
            self.textField.textColor = self.theme.getInputFieldTextColor()
            self.hintLabel.text = ""
        }
    }
    
    
    /**
     Delegate method when text field did begin editing
     
     - parameter textField: The `UITextField` that has begun editing
     */
    open func textFieldDidBeginEditing(_ textField: UITextField) {
        self.setActive(true)
        self.delegate?.judoPayInputDidChangeText(self)
    }
    
    /**
     Delegate method when text field did end editing
     
     - parameter textField: the `UITextField` that has ended editing
     */
    open func textFieldDidEndEditing(_ textField: UITextField) {
        self.setActive(textField.text?.characters.count > 0)
    }
    
}

extension JudoPayInputField: JudoInputType {
    
    /**
     Checks if the receiving input field has content that is valid
     
     - returns: true if valid input
     */
    public func isValid() -> Bool {
        return false
    }
    
    
    /**
     Helper call for delegate method
     */
    public func didChangeInputText() {
        self.delegate?.judoPayInputDidChangeText(self)
    }
    
    
    /**
     Subclassed method that is called when text field content was changed
     
     - parameter textField: the textfield of which the content has changed
     */
    public func textFieldDidChangeValue(_ textField: UITextField) {
        self.dismissError()
        // Method for subclassing
    }
    
    
    /**
     The placeholder string for the current input field
     
     - returns: an Attributed String that is the placeholder of the receiver
     */
    public func placeholder() -> NSAttributedString? {
        return nil
    }
    
    
    /**
     Boolean indicating whether the receiver has to show a logo
     
     - returns: true if inputField shows a Logo
     */
    public func containsLogo() -> Bool {
        return false
    }
    
    
    /**
     If the receiving input field contains a logo, this method returns Some
     
     - returns: an optional CardLogoView
     */
    public func logoView() -> CardLogoView? {
        return nil
    }
    
    
    /**
     Title of the receiver input field
     
     - returns: a string that is the title of the receiver
     */
    public func title() -> String {
        return ""
    }
    
    
    /**
     Width of the title
     
     - returns: width of the title
     */
    public func titleWidth() -> Int {
        return 50
    }
    
    
    /**
     Hint label text
     
     - returns: string that is shown as a hint when user resides in a inputField for more than 5 seconds
     */
    public func hintLabelText() -> String {
        return ""
    }
    
    public func displayHint(message: String) {
        self.hintLabel.text = message
        self.hintLabel.textColor = self.theme.getInputFieldHintTextColor()
        self.updateConstraints(message: message)
    }
    
    public func displayError(message: String) {
        self.hintLabel.text = message
        self.hintLabel.textColor = self.theme.getErrorColor()
        self.updateConstraints(message: message)
    }
    
    private func updateConstraints(message: String) {
        self.heightConstraint.constant = message.characters.count == 0 ? 50 : self.theme.inputFieldHeight
        self.layoutIfNeeded()
    }
    
    private  func setRedBlockFrameAndBackgroundColor(height: CGFloat, backgroundColor: UIColor) {
        self.redBlock.backgroundColor = backgroundColor
        let yPosition:CGFloat = self.frame.size.height == 50 ? 4 : 22;
        self.redBlock.frame = CGRect(x: 13.0, y: self.frame.size.height - yPosition, width: self.frame.size.width - 26.0, height: height)
    }
    
    func redBlockAsError() {
        self.setRedBlockFrameAndBackgroundColor(height: 2.0, backgroundColor: self.theme.getErrorColor())
    }
    
    func redBlockAsUnactive() {
        self.setRedBlockFrameAndBackgroundColor(height: 0.5, backgroundColor: self.theme.getInputFieldBorderColor().withAlphaComponent(0.5))
    }
    
    func  redBlockAsActive() {
        self.setRedBlockFrameAndBackgroundColor(height: 0.5, backgroundColor: self.theme.getInputFieldBorderColor().withAlphaComponent(1.0))
    }
}

