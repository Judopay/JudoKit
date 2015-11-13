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
import JudoShield

// MARK: Constants

// Buttons
let kPaymentButtonTitle = "Pay"
let kRegisterCardButtonTitle = "Add"

let kBackButtonTitle = "Back"

// Titles
let kPaymentTitle = "Payment"
let kRegisterCardTitle = "Add card"
let kRefundTitle = "Refund"
let kRedirecting3DSTitle = "Redirecting..."
let kAuthenticationTitle = "Authentication"
let kVerifying3DSPaymentTitle = "Verifying payment"
let kVerifying3DSRegisterCardTitle = "Verifying card"

// Loading
let kLoadingIndicatorRegisterCardTitle = "Adding Card..."
let kLoadingIndicatorProcessingTitle = "Processing payment..."

// InputFields
let inputFieldHeight: CGFloat = 48


/**
 
 the JPayViewController is the one solution build to guide a user through the journey of entering their card details.
 
 */
public class JPayViewController: UIViewController, UIWebViewDelegate, JudoPayInputDelegate {
    
    private let contentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.directionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // MARK: Transaction variables
    
    /// The amount and currency to process, amount to two decimal places and currency in string
    public private (set) var amount: Amount?
    /// the number (e.g. "123-456" or "654321") identifying the Merchant you wish to pay
    public private (set) var judoID: String?
    /// Your reference for this consumer, this payment and An object containing any additional data you wish to tag this payment with. The property name and value are both limited to 50 characters, and the whole object cannot be more than 1024 characters
    public private (set) var reference: Reference?
    /// The card details object
    public private (set) var cardDetails: CardDetails?
    /// Card token and Consumer token
    public private (set) var paymentToken: PaymentToken?
    
    private let transactionType: TransactionType
    
    // MARK: Fraud Prevention
    private let judoShield = JudoShield()
    private var currentLocation: CLLocationCoordinate2D?
    
    // MARK: 3DS variables
    private var pending3DSTransaction: Transaction?
    private var pending3DSReceiptID: String?
    
    // MARK: TextField Layout
    /// the layout type for the input fields
    var layout: LayoutType = .Above
    
    // MARK: UI properties
    private var paymentEnabled = false
    private var currentKeyboardHeight: CGFloat = 0.0
    
    /// the phantom keyboard height constraint
    var keyboardHeightConstraint: NSLayoutConstraint?
    
    /// the maestro card fields (issue number and start date) height constraint)
    var maestroFieldsHeightConstraint: NSLayoutConstraint?
    /// the billing country field height constraint
    var billingHeightConstraint: NSLayoutConstraint?
    /// the postal code field height constraint
    var postHeightConstraint: NSLayoutConstraint?
    
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
    
    /// the hint label object
    let hintLabel = UILabel(frame: CGRectZero)

    // can not initialize because self is not available at this point to set the target
    // must be var? because can also not be initialized in init before self is available
    /// payment navbar button
    var paymentNavBarButton: UIBarButtonItem?
    /// the payment button object
    let paymentButton = PayButton()
    
    private let loadingView = LoadingView()
    private let threeDSecureWebView = _DSWebView()
    
    // MARK: completion blocks
    private var completionBlock: ((Response?, JudoError?) -> ())?
    private var encounterErrorBlock: (JudoError -> ())?
    
    // MARK: hint label
    private var timer: NSTimer?
    
    // MARK: Keyboard notification configuration
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    /**
     Initialiser to start a payment journey
     
     - parameter judoID:           the judoID of the recipient
     - parameter amount:           an amount and currency for the transaction
     - parameter reference:        a Reference for the transaction
     - parameter transactionType:  the type of the transaction
     - parameter completion:       completion block called when transaction has been finished
     - parameter encounteredError: a block that is called when non-fatal errors occured
     - parameter cardDetails:      an object containing all card information - default: nil
     - parameter paymentToken:     a payment token if a payment by token is to be made - default: nil
     
     - returns: a JPayViewController object for presentation on a view stack
     */
    public init(judoID: String, amount: Amount, reference: Reference, transactionType: TransactionType = .Payment, completion: (Response?, JudoError?) -> (), encounteredError: JudoError -> (), cardDetails: CardDetails? = nil, paymentToken: PaymentToken? = nil) {
        self.judoID = judoID
        self.amount = amount
        self.reference = reference
        self.cardDetails = cardDetails
        self.paymentToken = paymentToken
        self.transactionType = transactionType
        self.completionBlock = completion
        self.encounterErrorBlock = encounteredError
        
        super.init(nibName: nil, bundle: nil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    /**
     designated initialiser that will fail if called
     
     - parameter nibNameOrNil:   nib name or nil
     - parameter nibBundleOrNil: bundle or nil
     
     - returns: will crash if executed
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("This class should not be initialised with initWithNibName:Bundle:")
    }
    
    /**
     designated initialiser that will fail if called
     
     - parameter aDecoder: a decoder
     
     - returns: will crash if executed
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        fatalError("This class should not be initialised with initWithCoder:")
    }
    
    
    /**
     this method will receive the height of the keyboard when the keyboard will appear to fit the size of the contentview accordingly
     
     - parameter note: the notification that calls this method
     */
    func keyboardWillShow(note: NSNotification) {
        guard self.navigationController?.traitCollection.userInterfaceIdiom == .Phone else { return } // BAIL
        
        guard let info = note.userInfo else { return } // BAIL
        
        guard let animationCurve = info[UIKeyboardAnimationCurveUserInfoKey],
            let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey] else { return } // BAIL
        
        guard let keyboardRect = info[UIKeyboardFrameEndUserInfoKey]?.CGRectValue else { return } // BAIL
        
        self.currentKeyboardHeight = keyboardRect.height
        
        self.keyboardHeightConstraint!.constant = -1 * keyboardRect.height + (paymentEnabled ? 0 : self.paymentButton.bounds.height)
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
        guard self.navigationController?.traitCollection.userInterfaceIdiom == .Phone else { return } // BAIL
        
        guard let info = note.userInfo else { return } // BAIL
        
        guard let animationCurve = info[UIKeyboardAnimationCurveUserInfoKey],
            let animationDuration = info[UIKeyboardAnimationDurationUserInfoKey] else { return } // BAIL
        
        self.currentKeyboardHeight = 0.0

        self.keyboardHeightConstraint!.constant = 0.0 + (paymentEnabled ? 0 : self.paymentButton.bounds.height)
        self.paymentButton.setNeedsUpdateConstraints()

        UIView.animateWithDuration(animationDuration.doubleValue, delay: 0.0, options:UIViewAnimationOptions(rawValue: (animationCurve as! UInt)), animations: { () -> Void in
            self.paymentButton.layoutIfNeeded()
        }, completion: nil)
    }
    
    // MARK: View Lifecycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        switch self.transactionType {
        case .Payment, .PreAuth:
            self.title = kPaymentTitle
        case .RegisterCard:
            self.title = kRegisterCardTitle
        case .Refund:
            self.title = kRefundTitle
        }
        
        var payButtonTitle = kPaymentButtonTitle
        self.loadingView.actionLabel.text = kLoadingIndicatorProcessingTitle
        
        if self.transactionType == .RegisterCard {
            payButtonTitle = kRegisterCardButtonTitle
            self.loadingView.actionLabel.text = kLoadingIndicatorRegisterCardTitle
        }
        
        self.paymentButton.setTitle(payButtonTitle, forState: .Normal)
        
        self.startDateInputField.isStartDate = true
        
        // view
        self.view.addSubview(contentView)
        self.contentView.contentSize = self.view.bounds.size
        
        self.view.backgroundColor = .judoContentViewBackgroundColor()
        
        self.contentView.addSubview(cardInputField)
        self.contentView.addSubview(startDateInputField)
        self.contentView.addSubview(issueNumberInputField)
        self.contentView.addSubview(expiryDateInputField)
        self.contentView.addSubview(secureCodeInputField)
        self.contentView.addSubview(billingCountryInputField)
        self.contentView.addSubview(postCodeInputField)
        self.contentView.addSubview(hintLabel)
        
        self.view.addSubview(paymentButton)
        self.view.addSubview(threeDSecureWebView)
        self.view.addSubview(loadingView)
        
        // delegates
        self.cardInputField.delegate = self
        self.expiryDateInputField.delegate = self
        self.secureCodeInputField.delegate = self
        self.issueNumberInputField.delegate = self
        self.startDateInputField.delegate = self
        self.billingCountryInputField.delegate = self
        self.postCodeInputField.delegate = self
        self.threeDSecureWebView.delegate = self
        
        self.hintLabel.font = UIFont.systemFontOfSize(14)
        self.hintLabel.textColor = UIColor.judoDarkGrayColor()
        self.hintLabel.numberOfLines = 3
        self.hintLabel.alpha = 0.0
        self.hintLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // layout constraints
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[scrollView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView":contentView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]-1-[button]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["scrollView":contentView, "button":paymentButton]))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[loadingView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["loadingView":loadingView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[loadingView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["loadingView":loadingView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[tdsecure]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tdsecure":threeDSecureWebView]))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(68)-[tdsecure]-(30)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["tdsecure":threeDSecureWebView]))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|[button]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["button":paymentButton]))
        
        self.keyboardHeightConstraint = NSLayoutConstraint(item: paymentButton, attribute: .Bottom, relatedBy: .Equal, toItem: self.view, attribute: .Bottom, multiplier: 1.0, constant: paymentEnabled ? 0 : 50)
        self.view.addConstraint(keyboardHeightConstraint!)
        self.paymentButton.addConstraint(NSLayoutConstraint(item: paymentButton, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 50))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[card]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics:nil, views: ["card":cardInputField]))
        self.contentView.addConstraint(NSLayoutConstraint(item: cardInputField, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: self.contentView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 2))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[expiry]-(-1)-[security(==expiry)]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["expiry":expiryDateInputField, "security":secureCodeInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[start]-(-1)-[issue(==start)]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["start":startDateInputField, "issue":issueNumberInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[billing]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["billing":billingCountryInputField]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(12)-[hint]-(12)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["hint":hintLabel]))
        
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[post]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["post":postCodeInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[card(fieldHeight)]-(-1)-[start]-(-1)-[expiry(fieldHeight)]-(-1)-[billing]-(-1)-[post]-[hint(34)]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["fieldHeight":inputFieldHeight], views: ["card":cardInputField, "start":startDateInputField, "expiry":expiryDateInputField, "billing":billingCountryInputField, "post":postCodeInputField, "hint":hintLabel]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[card(fieldHeight)]-(-1)-[issue(==start)]-(-1)-[security(fieldHeight)]-(-1)-[billing]-(-1)-[post]-[hint]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["fieldHeight":inputFieldHeight], views: ["card":cardInputField, "issue":issueNumberInputField, "start":startDateInputField, "security":secureCodeInputField, "post":postCodeInputField, "billing":billingCountryInputField, "hint":hintLabel]))
        
        self.maestroFieldsHeightConstraint = NSLayoutConstraint(item: startDateInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        self.billingHeightConstraint = NSLayoutConstraint(item: billingCountryInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        self.postHeightConstraint = NSLayoutConstraint(item: postCodeInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        
        self.startDateInputField.addConstraint(maestroFieldsHeightConstraint!)
        self.billingCountryInputField.addConstraint(billingHeightConstraint!)
        self.postCodeInputField.addConstraint(postHeightConstraint!)
        
        // button actions
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: kBackButtonTitle, style: .Plain, target: self, action: Selector("doneButtonAction:"))
        self.paymentNavBarButton = UIBarButtonItem(title: payButtonTitle, style: .Done, target: self, action: Selector("payButtonAction:"))
        self.paymentNavBarButton!.enabled = false
        self.navigationItem.rightBarButtonItem = self.paymentNavBarButton
        
        self.paymentButton.addTarget(self, action: Selector("payButtonAction:"), forControlEvents: .TouchUpInside)
        
        self.navigationController?.navigationBar.tintColor = .judoDarkGrayColor()
        if !UIColor.colorMode() {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.judoDarkGrayColor()]
        
        // if card details are available, fill out the fields
        if let cardDetails = self.cardDetails,
            let cardLastFour = cardDetails.cardLastFour,
            let expiryDate = cardDetails.endDate {
            self.cardInputField.textField().text = "**** " + cardLastFour
            self.expiryDateInputField.textField().text = expiryDate
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.judoShield.locationWithCompletion { (coordinate, error) -> Void in
            if let err = error as? JudoError {
                self.encounterErrorBlock?(err)
            } else if coordinate.latitude != CLLocationDegrees(NSIntegerMax) {
                self.currentLocation = coordinate
            }
        }
        
        if self.cardInputField.textField().text?.characters.count > 0 {
            self.secureCodeInputField.textField().becomeFirstResponder()
        } else {
            self.cardInputField.textField().becomeFirstResponder()
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
        self.expiryDateInputField.textField().becomeFirstResponder()
    }
    
    public func cardInput(input: CardInputField, didDetectNetwork network: CardNetwork) {
        self.cardInputField.updateCardLogo()
        self.secureCodeInputField.cardNetwork = network
        self.secureCodeInputField.updateCardLogo()
        self.secureCodeInputField.titleLabel.text = network.securityCodeTitle()
        self.toggleStartDateVisibility(network == .Maestro)
    }
    
    // MARK: DateInputDelegate
    
    public func dateInput(input: DateInputField, error: JudoError) {
        input.errorAnimation(error.code != .InputLengthMismatchError)
    }
    
    public func dateInput(input: DateInputField, didFindValidDate date: String) {
        if input == self.startDateInputField {
            self.issueNumberInputField.textField().becomeFirstResponder()
        } else {
            self.secureCodeInputField.textField().becomeFirstResponder()
        }
    }
    
    // MARK: IssueNumberInputDelegate
    
    public func issueNumberInputDidEnterCode(inputField: IssueNumberInputField, issueNumber: String) {
        if issueNumber.characters.count == 3 {
            self.expiryDateInputField.textField().becomeFirstResponder()
        }
    }
    
    // MARK: BillingCountryInputDelegate
    
    public func billingCountryInputDidEnter(input: BillingCountryInputField, billingCountry: BillingCountry) {
        self.postCodeInputField.billingCountry = billingCountry
        // FIXME: maybe check if the postcode is still valid and then delete if nessecary
        self.postCodeInputField.textField().text = ""
        self.paymentEnabled(false)
    }
    
    // MARK: JudoPayInputDelegate
    
    public func judoPayInput(input: JudoPayInputField, isValid: Bool) {
        if input == self.postCodeInputField {
            self.paymentEnabled(isValid)
        } else if input == self.secureCodeInputField {
            if JudoKit.avsEnabled {
                if isValid {
                    self.postCodeInputField.textField().becomeFirstResponder()
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
    
    // MARK: UIWebViewDelegate
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        
        if let urlString = urlString where urlString.rangeOfString("Parse3DS") != nil {
            guard let body = request.HTTPBody,
                let bodyString = NSString(data: body, encoding: NSUTF8StringEncoding) else {
                    self.encounterErrorBlock?(JudoError(.Failed3DSError))
                    return false
            }
            
            var results = JSONDictionary()
            let pairs = bodyString.componentsSeparatedByString("&")
            
            for pair in pairs {
                if pair.rangeOfString("=") != nil {
                    let components = pair.componentsSeparatedByString("=")
                    let value = components[1]
                    let escapedVal = value.stringByRemovingPercentEncoding
                    
                    results[components[0]] = escapedVal
                }
            }
            
            if let receiptID = self.pending3DSReceiptID {
                if self.transactionType == .RegisterCard {
                    self.loadingView.actionLabel.text = kVerifying3DSRegisterCardTitle
                } else {
                    self.loadingView.actionLabel.text = kVerifying3DSPaymentTitle
                }
                self.loadingView.startAnimating()
                self.title = kAuthenticationTitle
                self.pending3DSTransaction?.threeDSecure(results, receiptID: receiptID, block: { (resp, error) -> () in
                    self.loadingView.stopAnimating()
                    if let error = error {
                        self.completionBlock?(nil, error)
                    } else if let resp = resp {
                        self.completionBlock?(resp, nil)
                    } else {
                        self.completionBlock?(nil, JudoError(.Unknown))
                    }
                })
            } else {
                self.completionBlock?(nil, JudoError(.Unknown))
            }
            
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.threeDSecureWebView.alpha = 0.0
            }, completion: { (didFinish) -> Void in
                self.threeDSecureWebView.loadRequest(NSURLRequest(URL: NSURL(string: "about:blank")!))
            })
            return false
        }
        return true
    }
    
    public func webViewDidFinishLoad(webView: UIWebView) {
        var alphaVal: CGFloat = 1.0
        if webView.request?.URL?.absoluteString == "about:blank" {
            alphaVal = 0.0
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.threeDSecureWebView.alpha = alphaVal
            self.loadingView.stopAnimating()
        })
    }
    
    // MARK: Button Actions
    
    
    /**
    When the user hits the pay button, the information is collected from the fields and passed to the backend. The transaction will then be executed
    
    - parameter sender: the payment button
    */
    func payButtonAction(sender: AnyObject) {
        guard let reference = self.reference,
            let amount = self.amount,
            let judoID = self.judoID else {
                self.completionBlock?(nil, JudoError(.ParameterError))
                return // BAIL
        }
        
        if self.secureCodeInputField.textField().isFirstResponder() {
            self.secureCodeInputField.textField().resignFirstResponder()
        } else if self.postCodeInputField.textField().isFirstResponder() {
            self.postCodeInputField.textField().resignFirstResponder()
        }
        
        self.loadingView.startAnimating()
        
        do {
            var transaction: Transaction?
            
            switch self.transactionType {
            case .Payment:
                transaction = try Judo.payment(judoID, amount: amount, reference: reference)
            case .PreAuth, .RegisterCard:
                transaction = try Judo.preAuth(judoID, amount: amount, reference: reference)
            case .Refund:
                assertionFailure("Refund not supported in this context")
                return
            }
            
            if let payToken = self.paymentToken {
                payToken.cv2 = self.secureCodeInputField.textField().text
                transaction = transaction?.paymentToken(payToken)
            } else {
                // I expect that all the texts are available because the Pay Button would not be active otherwise
                var address: Address? = nil
                if JudoKit.avsEnabled {
                    guard let postCode = self.postCodeInputField.textField().text else { return }
                    
                    address = Address(postCode: postCode, country: self.billingCountryInputField.selectedCountry)
                }
                
                var issueNumber: String? = nil
                var startDate: String? = nil
                
                if self.cardInputField.textField().text?.cardNetwork() == .Maestro {
                    issueNumber = self.issueNumberInputField.textField().text
                    startDate = self.startDateInputField.textField().text
                }
                
                transaction = transaction?.card(Card(number: self.cardInputField.textField().text!.strippedWhitespaces, expiryDate: self.expiryDateInputField.textField().text!, cv2: self.secureCodeInputField.textField().text!, address: address, startDate: startDate, issueNumber: issueNumber))
            }
            
            // if location was fetched until now, get it
            if let location = self.currentLocation {
                transaction = transaction?.location(location)
            }
            
            let deviceSignal = self.judoShield.deviceSignal() as JSONDictionary
            
            self.pending3DSTransaction = try transaction?.deviceSignal(deviceSignal).completion({ (response, error) -> () in
                if let error = error {
                    if error.domain == JudoErrorDomain && error.code == .ThreeDSAuthRequest {
                        guard let userInfo = error.userInfo else {
                            self.completionBlock?(nil, JudoError(.ResponseParseError))
                            return // BAIL
                        }
                        
                        do {
                            self.pending3DSReceiptID = try self.threeDSecureWebView.load3DSWithPayload(userInfo)
                        } catch {
                            self.loadingView.stopAnimating()
                            self.completionBlock?(nil, error as? JudoError)
                        }
                        self.loadingView.actionLabel.text = kRedirecting3DSTitle
                        self.title = kAuthenticationTitle
                        self.paymentEnabled(false)
                    } else {
                        self.completionBlock?(nil, error)
                        self.loadingView.stopAnimating()
                    }
                } else if let response = response {
                    self.completionBlock?(response, nil)
                    self.loadingView.stopAnimating()
                }
            })
            
        } catch let error as JudoError {
            self.completionBlock?(nil, error)
            self.loadingView.stopAnimating()
        } catch {
            self.completionBlock?(nil, JudoError(.Unknown))
            self.loadingView.stopAnimating()
        }
    }
    
    
    /**
     executed if the user hits the "Back" button
     
     - parameter sender: the button
     */
    func doneButtonAction(sender: UIBarButtonItem) {
        self.encounterErrorBlock?(JudoError(.UserDidCancel))
    }
    
    // MARK: Helpers
    
    
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

