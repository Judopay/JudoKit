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

/**
 
 The LayoutType enum declares the View type of the JudoPayInputField
 
 - Parameter Aside: The Title is shown statically on the left side
 - Parameter Above: The Title is shown floating when user starts entering details
 
 */
public enum LayoutType {
    
    /// - Case Aside: side-by-side layout
    case Aside
    /// - Case Above: Floating title layout
    case Above
    
    /**
     returns the format in AutoLayout visual language for a given InputField LayoutType
     
     - parameter containsLogo: wether the inputField should contain a Logo on the right side or not
     - parameter titleWidth:   the width of a given title if the view is in side by side mode
     
     - returns: a String with the autolayout visual format for a given judoPayInputField
     */
    func autoLayout(containsLogo: Bool, titleWidth: Int) -> String {
        switch self {
        case .Aside where containsLogo:
            return "|-13-[title(\(titleWidth))][text][logo(38)]-13-|"
        case .Above where containsLogo:
            return "|-13-[text][logo(38)]-13-|"
        case .Aside where !containsLogo:
            return "|-13-[title(\(titleWidth))][text]-13-|"
        default: // .Above where !containsLogo:
            return "|-13-[text]-13-|"
        }
    }
}

/**
 
 The JudoPayInputDelegate is a delegate protocol that is used to pass information about the state of entering information for making transactions
 
 */
public protocol JudoPayInputDelegate {

    /**
     Delegate method that is triggered when the issueNumberInputField entered a code
     
     - parameter input:       the issueNumberInputField calling the delegate method
     - parameter issueNumber: the issue number that has been entered as a String
     */
    func issueNumberInputDidEnterCode(input: IssueNumberInputField, issueNumber: String)
    
    
    /**
     Delegate method that is triggered when the CardInputField encountered an error
     
     - parameter input: the input field calling the delegate method
     - parameter error: the error that occured
     */
    func cardInput(input: CardInputField, error: JudoError)
    
    /**
     Delegate method that is triggered when the CardInputField did find a valid number
     
     - parameter input:            the input field calling the delegate method
     - parameter cardNumberString: the card number that has been entered as a String
     */
    func cardInput(input: CardInputField, didFindValidNumber cardNumberString: String)
    
    /**
     Delegate method that is triggered when the CardInputField detected a network
     
     - parameter input:   the input field calling the delegate method
     - parameter network: the network that has been identified
     */
    func cardInput(input: CardInputField, didDetectNetwork network: CardNetwork)
    
    
    /**
     Delegate method that is triggered when the date input field has encountered an error
     
     - parameter input: the input field calling the delegate method
     - parameter error: the error that occured
     */
    func dateInput(input: DateInputField, error: JudoError)
    
    /**
     Delegate method that is triggered when the date input field has found a valid date
     
     - parameter input: the input field calling the delegate method
     - parameter date:  the valid date that has been entered
     */
    func dateInput(input: DateInputField, didFindValidDate date: String)
    
    
    /**
     Delegate method that is triggered when the judoPayInputField was validated
     
     - parameter input:   the input field calling the delegate method
     - parameter isValid: a boolean that indicates wether the input is valid or invalid
     */
    func judoPayInput(input: JudoPayInputField, isValid: Bool)
    
    
    /**
     Delegate method that is triggered when the billingCountry input field selected a BillingCountry
     
     - parameter input:          the input field calling the delegate method
     - parameter billingCountry: the billing country that has been selected
     */
    func billingCountryInputDidEnter(input: BillingCountryInputField, billingCountry: BillingCountry)
    
    
    /**
     Delegate method that is called whenever any inputField has been manipulated
     
     - parameter input: the input field calling the delegate method
     */
    func judoPayInputDidChangeText(input: JudoPayInputField)
}

/**
 
 The JudoPayInputField is a UIView subclass that is used to help to validate and visualize common information related to payments. This class delivers the common ground for the UI and UX. Textfields can either be used in a side-by-side motion (title on the left and input textfield on the right) or with a floating title that floats to the top as soon as a user starts entering their details)
 
 It is not recommended to use this class directly but rather use the subclasses of JudoPayInputField that are also provided in the JudoKit as this class does not do any validation which are necessary for making any kind of transaction.
 
 */
public class JudoPayInputField: UIView, UITextFieldDelegate {
    
    /// the delegate for the input field validation methods
    public var delegate: JudoPayInputDelegate?

    let floatingTextField: FloatingTextField = FloatingTextField()
    let asideTextField: UITextField = UITextField()
    
    let titleLabel: UILabel = UILabel()
    
    var layoutType: LayoutType
    
    lazy var logoContainerView: UIView = UIView()
    
    
    private let redBlock: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.judoRedColor()
        return view
    }()
    
    // MARK: Initializers
    
    /**
    Designated Initializer for JudoPayInputField
    
    - parameter layoutType: the layout type to use for
    
    - returns: a JudoPayInputField instance
    */
    public init(layoutType: LayoutType) {
        self.layoutType = layoutType
        super.init(frame: CGRectZero)
        self.setupView()
    }
    
    
    /**
     needed to create a convenience init method because default value on init with layoutType would be ambiguous.
     
     - returns: a JudoPayInputField instance
     */
    convenience public init() {
        self.init(layoutType: .Above)
    }
    
    
    /**
     required convenience method when creating JudoPayInputField with a CGRect
     
     - parameter frame: the frame is ignored
     
     - returns: a JudoPayInputField instance
     */
    convenience override public init(frame: CGRect) {
        self.init(layoutType: .Above)
    }
    
    
    /**
     required initializer set as convenience to trigger the designated initializer that contains all necessary initialisation methods
     
     - parameter aDecoder: decoder is ignored
     
     - returns: a JudoPayInputField instance
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        self.init(layoutType: .Above)
    }
    
    
    /**
     helper method to initialize the view
     */
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
    
    
    /**
    Helper method that will wiggle the inputField and show a red line at the bottom in which is was executed
    
    - parameter redBlock: boolean stating wether to show a red line at the bottom or not
    */
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
    
    
    /**
     in the case of an updated cardlogo, this method animates the change
     */
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
    
    
    /**
     set current object as active textfield visually
     
     - parameter isActive: boolean stating wether textfield has become active or inactive
     */
    public func setActive(isActive: Bool) {
        self.textField().alpha = isActive ? 1.0 : 0.5
        self.titleLabel.alpha = isActive ? 1.0 : 0.5
    }
    
    
    /**
     method that dismisses the error generated in the `errorAnmiation:` method
     */
    public func dismissError() {
        if self.redBlock.bounds.size.height > 0 {
            UIView.animateWithDuration(0.4) { () -> Void in
                self.redBlock.frame = CGRectMake(0.0, self.bounds.height, self.bounds.width, 4.0)
                self.titleLabel.textColor = .judoDarkGrayColor()
                self.textField().textColor = .judoDarkGrayColor()
            }
        }
    }
    
    
    /**
     Delegate method when textfield did begin editing
     
     - parameter textField: the `UITextField` that has begun editing
     */
    public func textFieldDidBeginEditing(textField: UITextField) {
        self.setActive(true)
        self.delegate?.judoPayInputDidChangeText(self)
    }
    
    /**
     Delegate method when textfield did end editing
     
     - parameter textField: the `UITextField` that has ended editing
     */
    public func textFieldDidEndEditing(textField: UITextField) {
        self.setActive(textField.text?.characters.count > 0)
    }
    
    
    /**
     a helper method to determine which textfield is the active textfield that is used to receive input information from the user
     
     - returns: depending on the configuration, the textfield that is receiving input calls is returned
     */
    public func textField() -> UITextField {
        if self.layoutType == .Aside {
            return self.asideTextField
        }
        return self.floatingTextField
    }
    
    // MARK: Custom methods
    
    
    /**
    Helper method for the hintLabel to disappear or reset the timer when called. This is triggered by the `shouldChangeCharactersInRange:` method in each of the `inputField` subclasses
    */
    func didChangeInputText() {
        self.delegate?.judoPayInputDidChangeText(self)
    }
    
    
    /**
     Method that is called after a value has changed. This method is intended for subclassing
     
     - parameter textField: the `UITextField` that has a changed value
     */
    func textFieldDidChangeValue(textField: UITextField) {
        self.dismissError()
        // method for subclassing
    }
    
    
    /**
     Placeholder string for textfields depending on layout configuration. This method is intended for subclassing
     
     - returns: an NSAttributedString depending on color and configuration
     */
    func placeholder() -> NSAttributedString? {
        if self.layoutType == .Above {
            return nil
        }
        return nil
    }
    
    
    /**
     an indication of wether an inputField contains a Logo or not. This method is intended for subclassing
     
     - returns: a boolean indication wether logo should be shown
     */
    func containsLogo() -> Bool {
        return false
    }
    
    
    /**
     the logo of an inputField if available. This method is intended for subclassing
     
     - returns: the logo of an inputField
     */
    func logoView() -> CardLogoView? {
        return nil
    }
    
    
    /**
     the title of an inputField. This method is intended for subclassing
     
     - returns: the title of an inputField
     */
    func title() -> String {
        return ""
    }
    
    
    /**
     the titleWidth for a given title and inputField. This method is intended for subclassing
     
     - returns: a title width in integer
     */
    func titleWidth() -> Int {
        return 50
    }
    
    
    /**
     a hint text for a given inputField. This method is intended for subclassing
     
     - returns: a String with instructions for a given inputField that pops up after 3 seconds of being idle
     */
    func hintLabelText() -> String {
        return ""
    }
    
}
