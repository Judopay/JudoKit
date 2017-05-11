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
 
 the JudoPayViewController is the one solution build to guide a user through the journey of entering their card details.
 
 */
open class JudoPayViewController: UIViewController {
    
    // MARK: Transaction variables
    
    /// the current JudoKit Session
    open var judoKitSession: JudoKit
    
    /// The amount and currency to process, amount to two decimal places and currency in string
    open fileprivate (set) var amount: Amount?
    /// The number (e.g. "123-456" or "654321") identifying the Merchant you wish to pay
    open fileprivate (set) var judoId: String?
    /// Your reference for this consumer, this payment and an object containing any additional data you wish to tag this payment with. The property name and value are both limited to 50 characters, and the whole object cannot be more than 1024 characters
    open fileprivate (set) var reference: Reference?
    /// Card token and Consumer token
    open fileprivate (set) var paymentToken: PaymentToken?
    
    /// The current transaction
    open let transaction: Transaction
    
    // MARK: 3DS variables
    fileprivate var pending3DSTransaction: Transaction?
    fileprivate var pending3DSReceiptID: String?
    
    // MARK: completion blocks
    fileprivate var completionBlock: JudoCompletionBlock?
    
    
    /// The overridden view object forwarding to a JudoPayView
    override open var view: UIView! {
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
     
     - parameter judoId:           The judoId of the recipient
     - parameter amount:           An amount and currency for the transaction
     - parameter reference:        A Reference for the transaction
     - parameter transactionType:  The type of the transaction
     - parameter completion:       Completion block called when transaction has been finished
     - parameter currentSession:   The current judo apiSession
     - parameter cardDetails:      An object containing all card information - default: nil
     - parameter paymentToken:     A payment token if a payment by token is to be made - default: nil
     
     - returns: a JPayViewController object for presentation on a view stack
     */
    public init(judoId: String, amount: Amount, reference: Reference, transactionType: TransactionType = .Payment, completion: @escaping JudoCompletionBlock, currentSession: JudoKit, cardDetails: CardDetails? = nil, paymentToken: PaymentToken? = nil)  throws {
        self.judoId = judoId
        self.amount = amount
        self.reference = reference
        self.paymentToken = paymentToken
        self.completionBlock = completion
        
        self.judoKitSession = currentSession
        self.myView = JudoPayView(type: transactionType, currentTheme: currentSession.theme, cardDetails: cardDetails, isTokenPayment: paymentToken != nil)
        
        self.transaction = try self.judoKitSession.transaction(self.myView.transactionType, judoId: judoId, amount: amount, reference: reference)
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    /**
     Designated initializer that will fail if called
     
     - parameter nibNameOrNil:   Nib name or nil
     - parameter nibBundleOrNil: Bundle or nil
     
     - returns: will crash if executed
     */
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
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
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.judoKitSession.apiSession.uiClientMode = true
        
        switch self.myView.transactionType {
        case .Payment, .PreAuth:
            self.title = self.judoKitSession.theme.paymentTitle
        case .RegisterCard:
            self.title = self.judoKitSession.theme.registerCardTitle
        case .Refund:
            self.title = self.judoKitSession.theme.refundTitle
        default:
            self.title = "Invalid"
        }

        self.myView.threeDSecureWebView.delegate = self
        
        // Button actions
        let payButtonTitle = self.myView.transactionType == .RegisterCard ? self.judoKitSession.theme.registerCardNavBarButtonTitle : self.judoKitSession.theme.paymentButtonTitle

        self.myView.paymentButton.addTarget(self, action: #selector(JudoPayViewController.payButtonAction(_:)), for: .touchUpInside)
        self.myView.paymentNavBarButton = UIBarButtonItem(title: payButtonTitle, style: .done, target: self, action: #selector(JudoPayViewController.payButtonAction(_:)))
        self.myView.paymentNavBarButton!.isEnabled = false

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: self.judoKitSession.theme.backButtonTitle, style: .plain, target: self, action: #selector(JudoPayViewController.doneButtonAction(_:)))
        self.navigationItem.rightBarButtonItem = self.myView.paymentNavBarButton
        
        self.navigationController?.navigationBar.tintColor = self.judoKitSession.theme.getTextColor()
        self.navigationController?.navigationBar.barTintColor = self.judoKitSession.theme.getNavigationBarBackgroundColor()
        if !self.judoKitSession.theme.colorMode() {
            self.navigationController?.navigationBar.barStyle = UIBarStyle.black
        }
        self.navigationController?.navigationBar.setBottomBorderColor(color: self.judoKitSession.theme.getNavigationBarBottomColor(), height: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:self.judoKitSession.theme.getNavigationBarTitleColor()]
        
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    
    /**
     viewWillAppear
     
     - parameter animated: Animated
     */
    open override func viewWillAppear(_ animated: Bool) {
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
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
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
    func payButtonAction(_ sender: AnyObject) {
        guard let reference = self.reference, let amount = self.amount, let judoId = self.judoId else {
            self.completionBlock?(nil, JudoError(.parameterError))
            return // BAIL
        }
        
        self.myView.secureCodeInputField.textField.resignFirstResponder()
        self.myView.postCodeInputField.textField.resignFirstResponder()
        
        self.myView.loadingView.startAnimating()
        
        do {
            let transaction = try self.judoKitSession.transaction(self.myView.transactionType, judoId: judoId, amount: amount, reference: reference)
            
            if var payToken = self.paymentToken {
                payToken.cv2 = self.myView.secureCodeInputField.textField.text
                transaction.paymentToken(payToken)
            } else {
                // I expect that all the texts are available because the Pay Button would not be active otherwise
                var address: Address? = nil
                if self.judoKitSession.theme.avsEnabled {
                    guard let postCode = self.myView.postCodeInputField.textField.text else { return }
                    
                    address = Address(postCode: postCode, country: self.myView.billingCountryInputField.selectedCountry)
                }
                
                var issueNumber: String? = nil
                var startDate: String? = nil
                
                if self.myView.cardInputField.textField.text?.cardNetwork() == .maestro {
                    issueNumber = self.myView.issueNumberInputField.textField.text
                    startDate = self.myView.startDateInputField.textField.text
                }
                
                var cardNumberString = self.myView.cardDetails?._cardNumber
                
                if cardNumberString == nil {
                    cardNumberString = self.myView.cardInputField.textField.text!.strippedWhitespaces
                }
                
                transaction.card(Card(number: cardNumberString!, expiryDate: self.myView.expiryDateInputField.textField.text!, securityCode: self.myView.secureCodeInputField.textField.text!, address: address, startDate: startDate, issueNumber: issueNumber))
            }
            
            try self.judoKitSession.completion(transaction, block: { [weak self] (response, error) -> () in
                if let error = error {
                    if error.domain == JudoErrorDomain && error.code == .threeDSAuthRequest {
                        guard let payload = error.payload else {
                            self?.completionBlock?(nil, JudoError(.responseParseError))
                            return // BAIL
                        }
                        
                        do {
                            self?.pending3DSTransaction = transaction
                            self?.pending3DSReceiptID = try self?.myView.threeDSecureWebView.load3DSWithPayload(payload)
                        } catch {
                            self?.myView.loadingView.stopAnimating()
                            self?.completionBlock?(nil, error as? JudoError)
                        }
                        self?.myView.loadingView.actionLabel.text = self?.judoKitSession.theme.redirecting3DSTitle
                        self?.title = self?.judoKitSession.theme.authenticationTitle
                        self?.myView.paymentEnabled(false)
                    } else {
                        self?.completionBlock?(nil, error)
                        self?.myView.loadingView.stopAnimating()
                    }
                } else if let response = response {
                    self?.completionBlock?(response, nil)
                    self?.myView.loadingView.stopAnimating()
                }
            })
            
        } catch let error as JudoError {
            self.completionBlock?(nil, error)
            self.myView.loadingView.stopAnimating()
        } catch {
            self.completionBlock?(nil, JudoError(.unknown))
            self.myView.loadingView.stopAnimating()
        }
    }
    
    
    /**
     executed if the user hits the "Back" button
     
     - parameter sender: the button
     */
    func doneButtonAction(_ sender: UIBarButtonItem) {
        self.completionBlock?(nil, JudoError(.userDidCancel))
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
    public func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlString = request.url?.absoluteString
        
        if let urlString = urlString , urlString.range(of: "Parse3DS") != nil {
            guard let body = request.httpBody,
                let bodyString = NSString(data: body, encoding: String.Encoding.utf8.rawValue) else {
                    self.completionBlock?(nil, JudoError(.failed3DSError))
                    return false
            }
            
            var results = JSONDictionary()
            let pairs = bodyString.components(separatedBy: "&")
            
            for pair in pairs {
                if pair.range(of: "=") != nil {
                    let components = pair.components(separatedBy: "=")
                    let value = components[1]
                    let escapedVal = value.removingPercentEncoding
                    
                    results[components[0]] = escapedVal as AnyObject?
                }
            }
            
            if let receiptId = self.pending3DSReceiptID {
                if self.myView.transactionType == .RegisterCard {
                    self.myView.loadingView.actionLabel.text = self.judoKitSession.theme.verifying3DSRegisterCardTitle
                } else {
                    self.myView.loadingView.actionLabel.text = self.judoKitSession.theme.verifying3DSPaymentTitle
                }
                self.myView.loadingView.startAnimating()
                self.title = self.judoKitSession.theme.authenticationTitle
                self.pending3DSTransaction?.threeDSecure(results, receiptId: receiptId, block: { [weak self] (resp, error) -> () in
                    self?.myView.loadingView.stopAnimating()
                    if let error = error {
                        self?.completionBlock?(nil, error)
                    } else if let resp = resp {
                        self?.completionBlock?(resp, nil)
                    } else {
                        self?.completionBlock?(nil, JudoError(.unknown))
                    }
                })
            } else {
                self.completionBlock?(nil, JudoError(.unknown))
            }
            
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                self.myView.threeDSecureWebView.alpha = 0.0
                }, completion: { (didFinish) -> Void in
                    self.myView.threeDSecureWebView.loadRequest(URLRequest(url: URL(string: "about:blank")!))
            })
            return false
        }
        return true
    }
    
    
    /**
     webView delegate method that indicates the webView has finished loading
     
     - parameter webView: The web view
     */
    public func webViewDidFinishLoad(_ webView: UIWebView) {
        var alphaVal: CGFloat = 1.0
        if webView.request?.url?.absoluteString == "about:blank" {
            alphaVal = 0.0
        }
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.myView.threeDSecureWebView.alpha = alphaVal
            self.myView.loadingView.stopAnimating()
        })
    }
    
    
    /**
     webView delegate method that indicates the webView has failed with an error
     
     - parameter webView: The web view
     - parameter error:   The error
     */
    public func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.myView.threeDSecureWebView.alpha = 0.0
            self.myView.loadingView.stopAnimating()
        })
        
        self.completionBlock?(nil, JudoError(.failed3DSError, bridgedError: error as NSError?))
    }
    
}
