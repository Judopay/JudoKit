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

public enum TransactionType {
    case Payment, PreAuth, RegisterCard
}

public class JPayViewController: UIViewController, UIWebViewDelegate, JudoPayInputDelegate {
    
    private let contentView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.directionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    // MARK: Transaction variables
    public private (set) var amount: Amount?
    public private (set) var judoID: String?
    public private (set) var reference: Reference?
    public private (set) var cardDetails: CardDetails?
    public private (set) var paymentToken: PaymentToken?
    
    private let transactionType: TransactionType
    
    // MARK: Fraud Prevention
    private let judoShield = JudoShield()
    private var currentLocation: CLLocationCoordinate2D?
    
    // MARK: 3DS variables
    private var pending3DSTransaction: Transaction?
    private var pending3DSReceiptID: String?
    
    // MARK: UI properties
    private var paymentEnabled = false
    private var currentKeyboardHeight = CGFloat(0.0)
    
    var keyboardHeightConstraint: NSLayoutConstraint?
    
    var maestroFieldsHeightConstraint: NSLayoutConstraint?
    var billingHeightConstraint: NSLayoutConstraint?
    var postHeightConstraint: NSLayoutConstraint?

    let cardInputField = CardInputField()
    let expiryDateInputField = DateInputField()
    let secureCodeInputField = SecurityInputField()
    let startDateInputField = DateInputField()
    let issueNumberInputField = IssueNumberInputField()
    let billingCountryInputField = BillingCountryInputField()
    let postCodeInputField = PostCodeInputField()

    // can not initialize because self is not available at this point
    // must be var? because can also not be initialized in init before self is available
    var paymentNavBarButton: UIBarButtonItem?
    let paymentButton = PayButton()
    private let loadingView = LoadingView()
    private let threeDSecureWebView = _DSWebView()
    
    // MARK: completion blocks
    private var completionBlock: TransactionBlock?
    private var encounterErrorBlock: ErrorHandlerBlock?
    
    // MARK: Keyboard notification configuration
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    public init(judoID: String, amount: Amount, reference: Reference, transactionType: TransactionType = .Payment, completion: TransactionBlock, encounteredError: ErrorHandlerBlock, cardDetails: CardDetails? = nil, paymentToken: PaymentToken? = nil) {
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
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        self.transactionType = .Payment
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.transactionType = .Payment
        super.init(coder: aDecoder)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillShow(note: NSNotification) {
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
    
    func keyboardWillHide(note: NSNotification) {
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
            self.title = "Payment"
        case .RegisterCard:
            self.title = "Add card"
        }
        
        var payButtonTitle = "Pay"
        if self.transactionType == .RegisterCard {
            payButtonTitle = "Add"
        }
        
        self.paymentButton.setTitle(payButtonTitle, forState: .Normal)
        
        self.startDateInputField.isStartDate = true

        // view
        self.view.addSubview(contentView)
        self.contentView.contentSize = self.view.bounds.size
        
        self.view.backgroundColor = .judoGrayColor()
        
        self.contentView.addSubview(cardInputField)
        self.contentView.addSubview(startDateInputField)
        self.contentView.addSubview(issueNumberInputField)
        self.contentView.addSubview(expiryDateInputField)
        self.contentView.addSubview(secureCodeInputField)
        self.contentView.addSubview(billingCountryInputField)
        self.contentView.addSubview(postCodeInputField)
        
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
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[start]-(-1)-[issue]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["start":startDateInputField, "issue":issueNumberInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[billing]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["billing":billingCountryInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(-1)-[post]-(-1)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["post":postCodeInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[card(44)]-(-1)-[start]-(-1)-[expiry(44)]-(-1)-[billing]-(-1)-[post]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["card":cardInputField, "start":startDateInputField, "expiry":expiryDateInputField, "billing":billingCountryInputField, "post":postCodeInputField]))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-15-[card(44)]-(-1)-[issue(==start)]-(-1)-[security(44)]-(-1)-[billing]-(-1)-[post]-(15)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["card":cardInputField, "issue":issueNumberInputField, "start":startDateInputField, "security":secureCodeInputField, "post":postCodeInputField, "billing":billingCountryInputField]))
        
        self.maestroFieldsHeightConstraint = NSLayoutConstraint(item: startDateInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        self.billingHeightConstraint = NSLayoutConstraint(item: billingCountryInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        self.postHeightConstraint = NSLayoutConstraint(item: postCodeInputField, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 0.0)
        
        self.startDateInputField.addConstraint(maestroFieldsHeightConstraint!)
        self.billingCountryInputField.addConstraint(billingHeightConstraint!)
        self.postCodeInputField.addConstraint(postHeightConstraint!)
        
        // button actions
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: self, action: Selector("doneButtonAction:"))
        self.paymentNavBarButton = UIBarButtonItem(title: payButtonTitle, style: .Done, target: self, action: Selector("payButtonAction:"))
        self.paymentNavBarButton!.enabled = false
        self.navigationItem.rightBarButtonItem = self.paymentNavBarButton
        
        self.paymentButton.addTarget(self, action: Selector("payButtonAction:"), forControlEvents: .TouchUpInside)
        
        self.navigationController?.navigationBar.tintColor = .judoDarkGrayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.judoDarkGrayColor()]
        
        // if card details are available, fill out the fields
        if let cardDetails = self.cardDetails,
            let cardLastFour = cardDetails.cardLastFour,
            let expiryDate = cardDetails.endDate {
            self.cardInputField.textField.text = "**** " + cardLastFour
            self.expiryDateInputField.textField.text = expiryDate
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.judoShield.locationWithCompletion { (coordinate, error) -> Void in
            if let _ = error {
//                self.encounterErrorBlock?(error as JudoError)
                // FIXME: think about error handling here
            } else {
                self.currentLocation = coordinate
            }
        }
        
        if self.cardInputField.textField.text?.characters.count > 0 {
            self.secureCodeInputField.textField.becomeFirstResponder()
        } else {
            self.cardInputField.textField.becomeFirstResponder()
        }
    }
    
    public func toggleStartDateVisibility(isVisible: Bool) {
        self.maestroFieldsHeightConstraint?.constant = isVisible ? 44 : 0
        self.issueNumberInputField.setNeedsUpdateConstraints()
        self.startDateInputField.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.2, delay: 0.0, options:UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.issueNumberInputField.layoutIfNeeded()
            self.startDateInputField.layoutIfNeeded()
            
            self.expiryDateInputField.layoutIfNeeded()
            self.secureCodeInputField.layoutIfNeeded()
            }, completion: nil)
    }

    public func toggleAVSVisibility(isVisible: Bool, completion: (() -> ())? = nil) {
        self.billingHeightConstraint?.constant = isVisible ? 44 : 0
        self.postHeightConstraint?.constant = isVisible ? 44 : 0
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
        input.errorAnimation(error != JudoError.InputLengthMismatchError)
    }
    
    public func cardInput(input: CardInputField, didFindValidNumber cardNumberString: String) {
        self.expiryDateInputField.textField.becomeFirstResponder()
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
        input.errorAnimation(error != JudoError.InputLengthMismatchError)
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
    
    // MARK: UIWebViewDelegate
    
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        
        if let urlString = urlString where urlString.rangeOfString("threedsecurecallback") != nil {
            guard let body = request.HTTPBody,
                let bodyString = NSString(data: body, encoding: NSUTF8StringEncoding) else {
                    self.encounterErrorBlock?(JudoError.Failed3DSError)
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
                self.pending3DSTransaction?.threeDSecure(results, receiptID: receiptID, block: { (resp, error) -> () in
                    if let error = error {
                        self.completionBlock?(nil, error)
                    } else if let resp = resp {
                        self.completionBlock?(resp, nil)
                    } else {
                        self.completionBlock?(nil, JudoError.Unknown as NSError)
                    }
                })
            } else {
                self.completionBlock?(nil, JudoError.Unknown as NSError)
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
        })
    }
    
    // MARK: Button Actions
    
    func payButtonAction(sender: AnyObject) {
        guard let reference = self.reference,
            let amount = self.amount,
            let judoID = self.judoID else {
                self.completionBlock?(nil, JudoError.ParameterError as NSError)
                return // BAIL
        }
        
        if self.secureCodeInputField.textField.isFirstResponder() {
            self.secureCodeInputField.textField.resignFirstResponder()
        } else if self.postCodeInputField.textField.isFirstResponder() {
            self.postCodeInputField.textField.resignFirstResponder()
        }
        
        self.loadingView.startAnimating()
        
        do {
            var transaction: Transaction?
            
            switch self.transactionType {
            case .Payment:
                transaction = try Judo.payment(judoID, amount: amount, reference: reference)
            case .PreAuth, .RegisterCard:
                transaction = try Judo.preAuth(judoID, amount: amount, reference: reference)
            }
            
            if let payToken = self.paymentToken {
                transaction = transaction?.paymentToken(payToken)
            } else {
                // I expect that all the texts are available because the Pay Button would not be active otherwise
                var address: Address? = nil
                if JudoKit.avsEnabled {
                    guard let postCode = self.postCodeInputField.textField.text else { return }
                    
                    address = Address(postCode: postCode, country: self.billingCountryInputField.selectedCountry)
                }
                
                var issueNumber: String? = nil
                var startDate: String? = nil
                
                if self.cardInputField.textField.text?.cardNetwork() == .Maestro {
                    issueNumber = self.issueNumberInputField.textField.text
                    startDate = self.startDateInputField.textField.text
                }
                
                transaction = transaction?.card(Card(number: self.cardInputField.textField.text!.stripped, expiryDate: self.expiryDateInputField.textField.text!, cv2: self.secureCodeInputField.textField.text!, address: address, startDate: startDate, issueNumber: issueNumber))
            }
            
            // if location was fetched until now, get it
            if let location = self.currentLocation {
                transaction = transaction?.location(location)
            }
            
            let deviceSignal = self.judoShield.deviceSignal() as JSONDictionary
            
            self.pending3DSTransaction = try transaction?.deviceSignal(deviceSignal).completion { (response, error) -> () in
                if let error = error {
                    // check for 3ds error
                    if error.domain == JudoErrorDomain && error.code == JudoError.ThreeDSAuthRequest.rawValue {
                        do {
                            self.pending3DSReceiptID = try self.threeDSecureWebView.load3DSWithPayload(error.userInfo as! JSONDictionary)
                        } catch let error as NSError {
                            self.completionBlock?(nil, error)
                        }
                        self.loadingView.actionLabel.text = "Redirecting..."
                        self.title = "Authentication"
                        self.paymentEnabled(false)
                    } else {
                        self.completionBlock?(nil, error)
                    }
                } else if let response = response {
                    self.completionBlock?(response, nil)
                }
                self.loadingView.stopAnimating()
            }
        } catch let error as NSError {
            self.completionBlock?(nil, error)
            self.loadingView.stopAnimating()
        }
    }
    
    func doneButtonAction(sender: UIBarButtonItem) {
        self.encounterErrorBlock?(JudoError.UserDidCancel)
    }
    
    // MARK: Helpers
    
    func paymentEnabled(enabled: Bool) {
        self.paymentEnabled = enabled
        self.keyboardHeightConstraint?.constant = -self.currentKeyboardHeight + (paymentEnabled ? 0 : self.paymentButton.bounds.height)

        self.paymentButton.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.25, delay: 0.0, options:enabled ? .CurveEaseOut : .CurveEaseIn, animations: { () -> Void in
            self.paymentButton.layoutIfNeeded()
            }, completion: nil)

        self.paymentNavBarButton!.enabled = enabled
    }
    
}
