//
//  JPayViewController.swift
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


// MARK: Constants

// Buttons
let kPaymentButtonTitle = "Pay"
let kRegisterCardButtonTitle = "Add card"
let kRegisterCardNavBarButtonTitle = "Add"

let kBackButtonTitle = "Back"

// Titles
let kPaymentTitle = "Payment"
let kRegisterCardTitle = "Add card"
let kRefundTitle = "Refund"
let kAuthenticationTitle = "Authentication"

// Loading
let kLoadingIndicatorRegisterCardTitle = "Adding card..."
let kLoadingIndicatorProcessingTitle = "Processing payment..."
let kRedirecting3DSTitle = "Redirecting..."
let kVerifying3DSPaymentTitle = "Verifying payment"
let kVerifying3DSRegisterCardTitle = "Verifying card"

// InputFields
let inputFieldHeight: CGFloat = 48



public class JudoPayView: UIView, JudoPayInputDelegate {
    
    public let contentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.directionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    /// the card input field object
    let cardInputField = CardInputField()
    /// the expiry date input field object
    let expiryDateInputField = DateInputField()
    /// the secure code input field object
    let secureCodeInputField = SecurityInputField()
    /// the start date input field object
    let startDateInputField = DateInputField()
    /// the issue number input field object
    let issueNumberInputField = IssueNumberInputField()
    /// the billing country input field object
    let billingCountryInputField = BillingCountryInputField()
    /// the post code input field object
    let postCodeInputField = PostCodeInputField()

    /// The card details object
    var cardDetails: CardDetails?

    /// the phantom keyboard height constraint
    var keyboardHeightConstraint: NSLayoutConstraint?
    
    /// the maestro card fields (issue number and start date) height constraint)
    var maestroFieldsHeightConstraint: NSLayoutConstraint?
    /// the billing country field height constraint
    var billingHeightConstraint: NSLayoutConstraint?
    /// the postal code field height constraint
    var postHeightConstraint: NSLayoutConstraint?
    
    // MARK: UI properties
    var paymentEnabled = false
    var currentKeyboardHeight: CGFloat = 0.0
    
    /// the hint label object
    let hintLabel = UILabel(frame: CGRectZero)
    
    // can not initialize because self is not available at this point to set the target
    // must be var? because can also not be initialized in init before self is available
    /// payment navbar button
    var paymentNavBarButton: UIBarButtonItem?
    /// the payment button object
    let paymentButton = PayButton()
    
    let loadingView = LoadingView()
    let threeDSecureWebView = _DSWebView()
    
    // MARK: hint label
    private var timer: NSTimer?

    var transactionType: TransactionType
    
    public init(type: TransactionType, cardDetails: CardDetails? = nil) {
        self.transactionType = type
        self.cardDetails = cardDetails
        super.init(frame: UIScreen.mainScreen().bounds)
        
        self.setupView()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Keyboard notification configuration
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /**
     this method will receive the height of the keyboard when the keyboard will appear to fit the size of the contentview accordingly
     
     - parameter note: the notification that calls this method
     */
    func keyboardWillShow(note: NSNotification) {
        guard UI_USER_INTERFACE_IDIOM() == .Phone else { return } // BAIL
        
        guard let info = note.userInfo else { return } // BAIL
        
        guard let animationCurve = info[UIKeyboardAnimationCurveUserInfoKey],
            let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey] else { return } // BAIL
        
        guard let keyboardRect = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else { return } // BAIL
        
        self.currentKeyboardHeight = keyboardRect.height
        
        self.keyboardHeightConstraint!.constant = -1 * keyboardRect.height + (self.paymentEnabled ? 0 : self.paymentButton.bounds.height)
        self.paymentButton.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration.doubleValue, delay: 0.0, options:UIViewAnimationOptions(rawValue: (animationCurve as! UInt)), animations: { () -> Void in
            self.paymentButton.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    /**
     this method will receive the keyboard will disappear notification to fit the size of the contentview accordingly
     
     - parameter note: the notification that calls this method
     */
    func keyboardWillHide(note: NSNotification) {
        guard UI_USER_INTERFACE_IDIOM() == .Phone else { return } // BAIL
        
        guard let info = note.userInfo else { return } // BAIL
        
        guard let animationCurve = info[UIKeyboardAnimationCurveUserInfoKey],
            let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey] else { return } // BAIL
        
        self.currentKeyboardHeight = 0.0
        
        self.keyboardHeightConstraint!.constant = 0.0 + (self.paymentEnabled ? 0 : self.paymentButton.bounds.height)
        self.paymentButton.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(animationDuration.doubleValue, delay: 0.0, options:UIViewAnimationOptions(rawValue: (animationCurve as! UInt)), animations: { () -> Void in
            self.paymentButton.layoutIfNeeded()
            }, completion: nil)
    }
    
    // MARK: View LifeCycle

    func setupView() {
        let payButtonTitle = self.transactionType == .RegisterCard ? kRegisterCardTitle : kPaymentButtonTitle
        self.loadingView.actionLabel.text = self.transactionType == .RegisterCard ? kLoadingIndicatorRegisterCardTitle : kLoadingIndicatorProcessingTitle
        
        self.paymentButton.setTitle(payButtonTitle, forState: .Normal)
        
        self.startDateInputField.isStartDate = true
        
        // view
        self.addSubview(contentView)
        self.contentView.contentSize = self.bounds.size
        
        self.backgroundColor = .judoContentViewBackgroundColor()
        
        self.contentView.addSubview(cardInputField)
        self.contentView.addSubview(startDateInputField)
        self.contentView.addSubview(issueNumberInputField)
        self.contentView.addSubview(expiryDateInputField)
        self.contentView.addSubview(secureCodeInputField)
        self.contentView.addSubview(billingCountryInputField)
        self.contentView.addSubview(postCodeInputField)
        self.contentView.addSubview(hintLabel)
        
        self.addSubview(paymentButton)
        self.addSubview(threeDSecureWebView)
        self.addSubview(loadingView)
        
        // delegates
        self.cardInputField.delegate = self
        self.expiryDateInputField.delegate = self
        self.secureCodeInputField.delegate = self
        self.issueNumberInputField.delegate = self
        self.startDateInputField.delegate = self
        self.billingCountryInputField.delegate = self
        self.postCodeInputField.delegate = self
        
        self.hintLabel.font = UIFont.systemFontOfSize(14)
        self.hintLabel.textColor = UIColor.judoDarkGrayColor()
        self.hintLabel.numberOfLines = 3
        self.hintLabel.alpha = 0.0
        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // layout constraints
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView":contentView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]-1-[button]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView":contentView, "button":paymentButton]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[loadingView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["loadingView":loadingView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[loadingView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["loadingView":loadingView]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[tdsecure]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tdsecure":threeDSecureWebView]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(68)-[tdsecure]-(30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tdsecure":threeDSecureWebView]))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[button]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button":paymentButton]))
        self.paymentButton.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50))
        
        self.keyboardHeightConstraint = NSLayoutConstraint(item: paymentButton, attribute: .Bottom, relatedBy: .Equal, toItem: self, attribute: .Bottom, multiplier: 1.0, constant: paymentEnabled ? 0 : 50)
        self.addConstraint(keyboardHeightConstraint!)
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[card]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics:nil, views: ["card":cardInputField]))
        self.contentView.addConstraint(NSLayoutConstraint(item: cardInputField, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 2))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[expiry]-(-1)-[security(==expiry)]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["expiry":expiryDateInputField, "security":secureCodeInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[start]-(-1)-[issue(==start)]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["start":startDateInputField, "issue":issueNumberInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[billing]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["billing":billingCountryInputField]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(12)-[hint]-(12)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["hint":hintLabel]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[post]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["post":postCodeInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-75-[card(fieldHeight)]-(-1)-[start]-(-1)-[expiry(fieldHeight)]-(-1)-[billing]-(-1)-[post]-[hint(34)]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["fieldHeight":inputFieldHeight], views: ["card":cardInputField, "start":startDateInputField, "expiry":expiryDateInputField, "billing":billingCountryInputField, "post":postCodeInputField, "hint":hintLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-75-[card(fieldHeight)]-(-1)-[issue(==start)]-(-1)-[security(fieldHeight)]-(-1)-[billing]-(-1)-[post]-[hint]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["fieldHeight":inputFieldHeight], views: ["card":cardInputField, "issue":issueNumberInputField, "start":startDateInputField, "security":secureCodeInputField, "post":postCodeInputField, "billing":billingCountryInputField, "hint":hintLabel]))
        
        self.maestroFieldsHeightConstraint = NSLayoutConstraint(item: startDateInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        self.billingHeightConstraint = NSLayoutConstraint(item: billingCountryInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        self.postHeightConstraint = NSLayoutConstraint(item: postCodeInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        
        self.startDateInputField.addConstraint(maestroFieldsHeightConstraint!)
        self.billingCountryInputField.addConstraint(billingHeightConstraint!)
        self.postCodeInputField.addConstraint(postHeightConstraint!)
        
        // if card details are available, fill out the fields
        if let cardDetails = self.cardDetails,
            let formattedLastFour = cardDetails.formattedLastFour(),
            let expiryDate = cardDetails.formattedEndDate() {
                self.cardInputField.textField.text = formattedLastFour
                self.expiryDateInputField.textField.text = expiryDate
                self.updateInputFieldsWithNetwork(cardDetails.cardNetwork)
        }
    }
    
    /**
     This method is intended to toggle the start date and issue number fields visibility when a Card has been identified.
     
     - Discussion: Maestro cards need a start date or an issue number to be entered for making any transaction
     
     - parameter isVisible: wether start date and issue number fields should be visible
     */
    public func toggleStartDateVisibility(isVisible: Bool) {
        self.maestroFieldsHeightConstraint?.constant = isVisible ? inputFieldHeight : 0
        self.issueNumberInputField.setNeedsUpdateConstraints()
        self.startDateInputField.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.2, delay: 0.0, options:UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.issueNumberInputField.layoutIfNeeded()
            self.startDateInputField.layoutIfNeeded()
            
            self.expiryDateInputField.layoutIfNeeded()
            self.secureCodeInputField.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    /**
     This method toggles the visibility of address fields (billing country and post code).
     
     - Discussion: if AVS is necessary, this should be activated. AVS only needs Postcode to verify
     
     - parameter isVisible:  wether post code and billing country fields should be visible
     - parameter completion: block that is called when animation was finished
     */
    public func toggleAVSVisibility(isVisible: Bool, completion: (() -> ())? = nil) {
        self.billingHeightConstraint?.constant = isVisible ? inputFieldHeight : 0
        self.postHeightConstraint?.constant = isVisible ? inputFieldHeight : 0
        self.billingCountryInputField.setNeedsUpdateConstraints()
        self.postCodeInputField.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.billingCountryInputField.layoutIfNeeded()
            self.postCodeInputField.layoutIfNeeded()
            }) { (didFinish) -> Void in
                if let completion = completion {
                    completion()
                }
        }
    }
    
    
    // MARK: CardInputDelegate
    
    public func cardInput(input: CardInputField, error: JudoError) {
        input.errorAnimation(error.code != .InputLengthMismatchError)
    }
    
    public func cardInput(input: CardInputField, didFindValidNumber cardNumberString: String) {
        self.expiryDateInputField.textField.becomeFirstResponder()
    }
    
    public func cardInput(input: CardInputField, didDetectNetwork network: CardNetwork) {
        self.updateInputFieldsWithNetwork(network)
    }
    
    // MARK: DateInputDelegate
    
    public func dateInput(input: DateInputField, error: JudoError) {
        input.errorAnimation(error.code != .InputLengthMismatchError)
    }
    
    public func dateInput(input: DateInputField, didFindValidDate date: String) {
        if input == self.startDateInputField {
            self.issueNumberInputField.textField.becomeFirstResponder()
        } else {
            self.secureCodeInputField.textField.becomeFirstResponder()
        }
    }
    
    // MARK: IssueNumberInputDelegate
    
    public func issueNumberInputDidEnterCode(inputField: IssueNumberInputField, issueNumber: String) {
        if issueNumber.characters.count == 3 {
            self.expiryDateInputField.textField.becomeFirstResponder()
        }
    }
    
    // MARK: BillingCountryInputDelegate
    
    public func billingCountryInputDidEnter(input: BillingCountryInputField, billingCountry: BillingCountry) {
        self.postCodeInputField.billingCountry = billingCountry
        // FIXME: maybe check if the postcode is still valid and then delete if nessecary
        self.postCodeInputField.textField.text = ""
        self.paymentEnabled(false)
    }
    
    // MARK: JudoPayInputDelegate
    
    public func judoPayInput(input: JudoPayInputField, isValid: Bool) {
        if input == self.postCodeInputField {
            self.paymentEnabled(isValid)
        } else if input == self.secureCodeInputField {
            if JudoKit.avsEnabled {
                if isValid {
                    self.postCodeInputField.textField.becomeFirstResponder()
                    self.toggleAVSVisibility(true, completion: { () -> () in
                        self.contentView.scrollRectToVisible(self.postCodeInputField.frame, animated: true)
                    })
                }
            } else {
                self.paymentEnabled(isValid)
            }
        }
    }
    
    public func judoPayInputDidChangeText(input: JudoPayInputField) {
        self.resetTimerWithInput(input)
    }
    
    
    // MARK: Helpers
    
    
    /**
    when a network has been identified, the secure code textfield has to adjust its title and maximum number entry to enable the payment
    
    - parameter network: the network that has been identified
    */
    func updateInputFieldsWithNetwork(network: CardNetwork?) {
        guard let network = network else { return }
        self.cardInputField.updateCardLogo()
        self.secureCodeInputField.cardNetwork = network
        self.secureCodeInputField.updateCardLogo()
        self.secureCodeInputField.titleLabel.text = network.securityCodeTitle()
    }
    
    
    /**
    Helper method to enable the payment after all fields have been validated and entered
    
    - parameter enabled: pass true to enable the payment buttons
    */
    func paymentEnabled(enabled: Bool) {
        self.paymentEnabled = enabled
        if enabled {
            self.paymentButton.hidden = false
        }
        self.keyboardHeightConstraint?.constant = -self.currentKeyboardHeight + (paymentEnabled ? 0 : self.paymentButton.bounds.height)
        
        self.paymentButton.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.25, delay: 0.0, options:enabled ? .CurveEaseOut : .CurveEaseIn, animations: { () -> Void in
            self.paymentButton.layoutIfNeeded()
            }) { (didFinish) -> Void in
                self.paymentButton.hidden = !enabled
        }
        
        self.paymentNavBarButton!.enabled = enabled
    }
    
    
    /**
     The hint label has a timer that executes the visibility.
     
     - parameter input: the input field which the user is currently idling
     */
    func resetTimerWithInput(input: JudoPayInputField) {
        UIView.animateWithDuration(0.5) { () -> Void in
            self.hintLabel.alpha = 0.0
        }
        self.timer?.invalidate()
        self.timer = NSTimer.schedule(3.0, handler: { (timer) -> Void in
            self.hintLabel.text = input.hintLabelText()
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.hintLabel.alpha = 1.0
            })
        })
    }
    
}
