//
//  JudoPayViewController.swift
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
import JudoShield


/**
 
 the JudoPayViewController is the one solution build to guide a user through the journey of entering their card details.
 
 */
public class JudoPayViewController: UIViewController {
    
    // MARK: Transaction variables
    
    /// the current JudoKit Session
    public var judoSession: Judo
    
    /// The amount and currency to process, amount to two decimal places and currency in string
    public private (set) var amount: Amount?
    /// The number (e.g. "123-456" or "654321") identifying the Merchant you wish to pay
    public private (set) var judoID: String?
    /// Your reference for this consumer, this payment and an object containing any additional data you wish to tag this payment with. The property name and value are both limited to 50 characters, and the whole object cannot be more than 1024 characters
    public private (set) var reference: Reference?
    /// Card token and Consumer token
    public private (set) var paymentToken: PaymentToken?
    
    // MARK: Fraud Prevention
    private let judoShield = JudoShield()
    private var currentLocation: CLLocationCoordinate2D?
    
    // MARK: 3DS variables
    private var pending3DSTransaction: Transaction?
    private var pending3DSReceiptID: String?
    
    // MARK: completion blocks
    private var completionBlock: JudoCompletionBlock?
    
    
    /// The overridden view object forwarding to a JudoPayView
    override public var view: UIView! {
        get { return self.myView as UIView }
        set {
            if newValue is JudoPayView {
                myView = newValue as! JudoPayView
            }
            // Do nothing
        }
    }
    
    
    /// The main JudoPayView of this ViewController
    var myView: JudoPayView!
    
    
    /**
     Initializer to start a payment journey
     
     - parameter judoID:           The judoID of the recipient
     - parameter amount:           An amount and currency for the transaction
     - parameter reference:        A Reference for the transaction
     - parameter transactionType:  The type of the transaction
     - parameter completion:       Completion block called when transaction has been finished
     - parameter currentSession:   The current judo apiSession
     - parameter cardDetails:      An object containing all card information - default: nil
     - parameter paymentToken:     A payment token if a payment by token is to be made - default: nil
     
     - returns: a JPayViewController object for presentation on a view stack
     */
    public init(judoID: String, amount: Amount, reference: Reference, transactionType: TransactionType = .Payment, completion: JudoCompletionBlock, currentSession: Judo, cardDetails: CardDetails? = nil, paymentToken: PaymentToken? = nil) {
        self.judoID = judoID
        self.amount = amount
        self.reference = reference
        self.paymentToken = paymentToken
        self.completionBlock = completion
        
        self.judoSession = currentSession
        self.myView = JudoPayView(type: transactionType, cardDetails: cardDetails)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    /**
     Designated initializer that will fail if called
     
     - parameter nibNameOrNil:   Nib name or nil
     - parameter nibBundleOrNil: Bundle or nil
     
     - returns: will crash if executed
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        fatalError("This class should not be initialised with initWithNibName:Bundle:")
    }
    
    
    /**
     Designated initializer that will fail if called
     
     - parameter aDecoder: A decoder
     
     - returns: will crash if executed
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        fatalError("This class should not be initialised with initWithCoder:")
    }
    
    // MARK: View Lifecycle
    
    
    /**
    viewDidLoad
    */
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.judoSession.APISession.uiClientMode = true
        
        self.title = self.myView.transactionType.title()
        
        self.myView.threeDSecureWebView.delegate = self
        
        // Button actions
        let payButtonTitle = self.myView.transactionType == .RegisterCard ? JudoKit.theme.registerCardNavBarButtonTitle : JudoKit.theme.paymentButtonTitle

        self.myView.paymentButton.addTarget(self, action: #selector(JudoPayViewController.payButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.myView.paymentNavBarButton = UIBarButtonItem(title: payButtonTitle, style: .Done, target: self, action: #selector(JudoPayViewController.payButtonAction(_:)))
        self.myView.paymentNavBarButton!.enabled = false

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: JudoKit.theme.backButtonTitle, style: .Plain, target: self, action: #selector(JudoPayViewController.doneButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = self.myView.paymentNavBarButton
        
        self.navigationController?.navigationBar.tintColor = .judoDarkGrayColor()
        if !UIColor.colorMode() {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        }
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.judoDarkGrayColor()]
        
    }
    
    
    /**
     viewWillAppear
     
     - parameter animated: Animated
     */
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.myView.paymentEnabled(false)
        
        self.myView.layoutIfNeeded()
        
        if self.myView.cardDetails == nil && self.myView.cardInputField.textField.text != nil {
            self.myView.cardInputField.textFieldDidChangeValue(self.myView.cardInputField.textField)
            self.myView.expiryDateInputField.textFieldDidChangeValue(self.myView.expiryDateInputField.textField)
        }
    }
    
    
    /**
     viewDidAppear
     
     - parameter animated: Animated
     */
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.judoShield.locationWithCompletion { (coordinate, error) -> Void in
            if let _ = error as? JudoError {
                // silently fail
            } else if CLLocationCoordinate2DIsValid(coordinate) {
                self.currentLocation = coordinate
            }
        }
        
        if self.myView.cardInputField.textField.text?.characters.count > 0 {
            self.myView.secureCodeInputField.textField.becomeFirstResponder()
        } else {
            self.myView.cardInputField.textField.becomeFirstResponder()
        }
    }

    
    // MARK: Button Actions
    
    
    /**
    When the user hits the pay button, the information is collected from the fields and passed to the backend. The transaction will then be executed.
    
    - parameter sender: The payment button
    */
    func payButtonAction(sender: AnyObject) {
        guard let reference = self.reference, let amount = self.amount, let judoID = self.judoID else {
            self.completionBlock?(nil, JudoError(.ParameterError))
            return // BAIL
        }
        
        self.myView.secureCodeInputField.textField.resignFirstResponder()
        self.myView.postCodeInputField.textField.resignFirstResponder()
        
        self.myView.loadingView.startAnimating()
        
        do {
            let transaction = try judoSession.transaction(self.myView.transactionType, judoID: judoID, amount: amount, reference: reference)
            
            if let payToken = self.paymentToken {
                payToken.cv2 = self.myView.secureCodeInputField.textField.text
                transaction.paymentToken(payToken)
            } else {
                // I expect that all the texts are available because the Pay Button would not be active otherwise
                var address: Address? = nil
                if JudoKit.theme.avsEnabled {
                    guard let postCode = self.myView.postCodeInputField.textField.text else { return }
                    
                    address = Address(postCode: postCode, country: self.myView.billingCountryInputField.selectedCountry)
                }
                
                var issueNumber: String? = nil
                var startDate: String? = nil
                
                if self.myView.cardInputField.textField.text?.cardNetwork() == .Maestro {
                    issueNumber = self.myView.issueNumberInputField.textField.text
                    startDate = self.myView.startDateInputField.textField.text
                }
                
                transaction.card(Card(number: self.myView.cardInputField.textField.text!.strippedWhitespaces, expiryDate: self.myView.expiryDateInputField.textField.text!, cv2: self.myView.secureCodeInputField.textField.text!, address: address, startDate: startDate, issueNumber: issueNumber))
            }
            
            // If location was fetched until now, get it
            if let location = self.currentLocation {
                transaction.location(location)
            }
            
            self.pending3DSTransaction = try transaction.deviceSignal(self.judoShield.deviceSignal()).completion({ (response, error) -> () in
                if let error = error {
                    if error.domain == JudoErrorDomain && error.code == .ThreeDSAuthRequest {
                        guard let payload = error.payload else {
                            self.completionBlock?(nil, JudoError(.ResponseParseError))
                            return // BAIL
                        }
                        
                        do {
                            self.pending3DSReceiptID = try self.myView.threeDSecureWebView.load3DSWithPayload(payload)
                        } catch {
                            self.myView.loadingView.stopAnimating()
                            self.completionBlock?(nil, error as? JudoError)
                        }
                        self.myView.loadingView.actionLabel.text = JudoKit.theme.redirecting3DSTitle
                        self.title = JudoKit.theme.authenticationTitle
                        self.myView.paymentEnabled(false)
                    } else {
                        self.completionBlock?(nil, error)
                        self.myView.loadingView.stopAnimating()
                    }
                } else if let response = response {
                    self.completionBlock?(response, nil)
                    self.myView.loadingView.stopAnimating()
                }
            })
            
        } catch let error as JudoError {
            self.completionBlock?(nil, error)
            self.myView.loadingView.stopAnimating()
        } catch {
            self.completionBlock?(nil, JudoError(.Unknown))
            self.myView.loadingView.stopAnimating()
        }
    }
    
    
    /**
     executed if the user hits the "Back" button
     
     - parameter sender: the button
     */
    func doneButtonAction(sender: UIBarButtonItem) {
        self.completionBlock?(nil, JudoError(.UserDidCancel))
    }
    
}

// MARK: UIWebViewDelegate

extension JudoPayViewController: UIWebViewDelegate {
    
    /**
     webView delegate method
    
     - parameter webView:        The web view
     - parameter request:        The request that was called
     - parameter navigationType: The navigation Type
     
     - returns: return whether webView should start loading the request
     */
    public func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.URL?.absoluteString
        
        if let urlString = urlString where urlString.rangeOfString("Parse3DS") != nil {
            guard let body = request.HTTPBody,
                let bodyString = NSString(data: body, encoding: NSUTF8StringEncoding) else {
                    self.completionBlock?(nil, JudoError(.Failed3DSError))
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
                if self.myView.transactionType == .RegisterCard {
                    self.myView.loadingView.actionLabel.text = JudoKit.theme.verifying3DSRegisterCardTitle
                } else {
                    self.myView.loadingView.actionLabel.text = JudoKit.theme.verifying3DSPaymentTitle
                }
                self.myView.loadingView.startAnimating()
                self.title = JudoKit.theme.authenticationTitle
                self.pending3DSTransaction?.threeDSecure(results, receiptID: receiptID, block: { (resp, error) -> () in
                    self.myView.loadingView.stopAnimating()
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
                self.myView.threeDSecureWebView.alpha = 0.0
                }, completion: { (didFinish) -> Void in
                    self.myView.threeDSecureWebView.loadRequest(NSURLRequest(URL: NSURL(string: "about:blank")!))
            })
            return false
        }
        return true
    }
    
    
    /**
     webView delegate method that indicates the webView has finished loading
     
     - parameter webView: The web view
     */
    public func webViewDidFinishLoad(webView: UIWebView) {
        var alphaVal: CGFloat = 1.0
        if webView.request?.URL?.absoluteString == "about:blank" {
            alphaVal = 0.0
        }
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.myView.threeDSecureWebView.alpha = alphaVal
            self.myView.loadingView.stopAnimating()
        })
    }
    
    
    /**
     webView delegate method that indicates the webView has failed with an error
     
     - parameter webView: The web view
     - parameter error:   The error
     */
    public func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.myView.threeDSecureWebView.alpha = 0.0
            self.myView.loadingView.stopAnimating()
        })
        if error != nil {
            self.completionBlock?(nil, JudoError(.Failed3DSError, bridgedError: error!))
        } else {
            self.completionBlock?(nil, JudoError(.Failed3DSError))
        }
    }
    
}
