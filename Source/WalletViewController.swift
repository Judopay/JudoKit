//
//  WalletViewController.swift
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

open class WalletViewController: UIViewController {
    
    /// the current JudoKit Session
    open var judoKitSession: JudoKit
    
    /// The overridden view object forwarding to a JudoPayView
    override open var view: UIView! {
        get { return self.myView as UIView }
        set {
            if newValue is WalletView {
                myView = newValue as! WalletView
            }
            // Do nothing
        }
    }
    
    
    /// The main JudoPayView of this ViewController
    var myView: WalletView!
    
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
    public init(currentSession: JudoKit) {
        
        self.judoKitSession = currentSession
        
        self.myView = WalletView(currentTheme: currentSession.theme)
        
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
        
        self.title = "Wallet"
        
//        self.myView.threeDSecureWebView.delegate = self
//        
//        // Button actions
//        let payButtonTitle = self.myView.transactionType == .RegisterCard ? self.judoKitSession.theme.registerCardNavBarButtonTitle : self.judoKitSession.theme.paymentButtonTitle
//        
//        self.myView.paymentButton.addTarget(self, action: #selector(JudoPayViewController.payButtonAction(_:)), for: .touchUpInside)
//        self.myView.paymentNavBarButton = UIBarButtonItem(title: payButtonTitle, style: .done, target: self, action: #selector(JudoPayViewController.payButtonAction(_:)))
//        self.myView.paymentNavBarButton!.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: self.judoKitSession.theme.backButtonTitle, style: .plain, target: self, action: #selector(self.doneButtonAction(_:)))
//        self.navigationItem.rightBarButtonItem = self.myView.paymentNavBarButton
        
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
        
        self.myView.layoutIfNeeded()
    }
    
    
    /**
     viewDidAppear
     
     - parameter animated: Animated
     */
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    
    /**
     executed if the user hits the "Back" button
     
     - parameter sender: the button
     */
    func doneButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
//        self.completionBlock?(nil, JudoError(.userDidCancel))
    }

}
