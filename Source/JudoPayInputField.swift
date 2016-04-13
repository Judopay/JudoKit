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
public class JudoPayInputField: UIView, UITextFieldDelegate, JudoInputType {
    
    /// The delegate for the input field validation methods
    public var delegate: JudoPayInputDelegate?
    
    /// the theme of the current judoKit session
    public var theme: Theme
    
    let textField: FloatingTextField = FloatingTextField()
    
    lazy var logoContainerView: UIView = UIView()
    
    
    private let redBlock: UIView = {
        let view = UIView()
        return view
    }()
    
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
        self.redBlock.backgroundColor = self.theme.judoRedColor()

        self.backgroundColor = self.theme.judoInputFieldBackgroundColor()
        self.clipsToBounds = true
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = self.theme.judoInputFieldBorderColor().CGColor
        self.layer.borderWidth = 0.5
        
        self.textField.delegate = self
        self.textField.keyboardType = .NumberPad
        
        self.addSubview(self.textField)
        self.addSubview(self.redBlock)
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.textField.textColor = self.theme.judoInputFieldTextColor()
        self.textField.tintColor = self.theme.tintColor
        self.textField.font = UIFont.boldSystemFontOfSize(14)
        self.textField.addTarget(self, action: #selector(JudoPayInputField.textFieldDidChangeValue(_:)), forControlEvents: .EditingChanged)
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[text]|", options: .AlignAllBaseline, metrics: nil, views: ["text":textField]))
        
        self.setActive(false)
        
        self.textField.attributedPlaceholder = NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName: self.theme.judoLightGrayColor()])
        
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
    Helper method that will wiggle the input field and show a red line at the bottom in which is was executed
    
    - parameter redBlock: Boolean stating whether to show a red line at the bottom or not
    */
    public func errorAnimation(redBlock: Bool) {
        // Animate the red block on the bottom
        
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
                self.textField.textColor = self.theme.judoRedColor()
                }, completion: blockAnimation)
        } else {
            blockAnimation(true)
        }
    }
    
    
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
                self.textField.textColor = self.theme.judoDarkGrayColor()
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
    
    
    // MARK: JudoInputType
    
    
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
    public func textFieldDidChangeValue(textField: UITextField) {
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
    
}
