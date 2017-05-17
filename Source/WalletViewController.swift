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
    
    /// The amount and currency to process, amount to two decimal places and currency in string
    open fileprivate (set) var amount: Amount?
    /// The number (e.g. "123-456" or "654321") identifying the Merchant you wish to pay
    open fileprivate (set) var judoId: String?
    /// Your reference for this consumer, this payment and an object containing any additional data you wish to tag this payment with. The property name and value are both limited to 50 characters, and the whole object cannot be more than 1024 characters
    open fileprivate (set) var reference: Reference?
    /// Card token and Consumer token
    open fileprivate (set) var paymentToken: PaymentToken?
    
    /// The main JudoPayView of this ViewController
    var myView: WalletView!
    
    var cardDetails: CardDetails?
    
    var alertController: UIAlertController?
    
    var walletService: WalletService!
    
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
    public init(judoId: String, amount: Amount, reference: Reference, currentSession: JudoKit) {
        
        self.judoId = judoId
        self.amount = amount
        self.reference = reference
        self.judoKitSession = currentSession
        let inMemoryRepository = InMemoryWalletRepository()
        self.walletService = WalletService.init(repo: inMemoryRepository)
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
        self.myView.delegate = self
        self.myView.walletService = walletService
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
        
//        self.myView.layoutIfNeeded()
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
    
    
    //MARK: instantiate add card view
    func addCardTokenOperation() {
        guard let ref = self.reference else { return }
        try! self.judoKitSession.invokeRegisterCard(self.judoId!, amount: Amount(decimalNumber: 0.01, currency: (self.amount?.currency)!), reference: ref, completion: { (response, error) -> () in
            self.dismissView()
            if let error = error {
                if error.code == .userDidCancel {
                    self.dismissView()
                    return
                }
                var errorTitle = "Error"
                if let errorCategory = error.category {
                    errorTitle = errorCategory.stringValue()
                }
                self.alertController = UIAlertController(title: errorTitle, message: error.message, preferredStyle: .alert)
                self.alertController!.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.dismissView()
                return // BAIL
            }
            if let resp = response, let transactionData = resp.items.first {
                self.cardDetails = transactionData.cardDetails
                self.paymentToken = transactionData.paymentToken()
    
                try! self.walletService.add(card: self.walletCardAdapter(cardDetails: self.cardDetails!))
                self.myView.contentView.reloadData()
            }
        })
    }
    
    func walletCardAdapter(cardDetails: CardDetails)->WalletCard{
    let walletCard = WalletCard.init(cardNumberLastFour: cardDetails.cardLastFour!, expiryDate: cardDetails.formattedEndDate()!, cardToken: cardDetails.cardToken!, cardType: (cardDetails.cardNetwork?.cardLogoType())!, assignedName: cardDetails.cardNetwork?.stringValue(), defaultPaymentMethod: true)
        return walletCard
    }
    
    func dismissView(){
        if (UIApplication.shared.keyWindow?.rootViewController?.isKind(of: UINavigationController.self))! {
            _=self.navigationController?.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension WalletViewController : WalletCardOperationProtocol {

    func onAddWalletCard() {
        self.addCardTokenOperation()
    }
}
