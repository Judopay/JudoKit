//
//  ViewController.swift
//  JudoKitApplePayExample
//
//  Created by Hamon Riazy on 19/10/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import PassKit
import JudoKit
import Judo

let judoID      = "<#YOUR JUDO-ID#>"
let reference   = Reference(consumerRef: "Consumer Reference")

class ViewController: UIViewController, PKPaymentAuthorizationViewControllerDelegate {

    let applePayButton = PKPaymentButton(type: .Buy, style: .Black)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applePayButton.addTarget(self, action:Selector("applePayButtonPressed"), forControlEvents:.TouchUpInside)

        self.view.addSubview(self.applePayButton)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.applePayButton.center = CGPointMake(self.view.center.x, self.view.center.y - 120.0)
        
        if PKPaymentAuthorizationViewController.canMakePayments() {
            self.applePayButton.hidden = false
        } else {
            self.applePayButton.hidden = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func applePayButtonPressed() {
        // Set up our payment request.
        let paymentRequest = PKPaymentRequest()
        
        /*
        Our merchant identifier needs to match what we previously set up in
        the Capabilities window (or the developer portal).
        */
        paymentRequest.merchantIdentifier = "merchant.com.judo.demo1"
        
        /*
        Both country code and currency code are standard ISO formats. Country
        should be the region you will process the payment in. Currency should
        be the currency you would like to charge in.
        */
        paymentRequest.countryCode = "GB"
        paymentRequest.currencyCode = "GBP"
        
        // The networks we are able to accept.
        paymentRequest.supportedNetworks = [PKPaymentNetworkAmex, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa]
        
        /*
        Ask your payment processor what settings are right for your app. In
        most cases you will want to leave this set to .Capability3DS.
        */
        paymentRequest.merchantCapabilities = .Capability3DS
        
        /*
        An array of `PKPaymentSummaryItems` that we'd like to display on the
        sheet (see the summaryItems function).
        */
        paymentRequest.paymentSummaryItems = makeSummaryItems(requiresInternationalSurcharge: false)
        
        // Request shipping information, in this case just postal address.
        paymentRequest.requiredShippingAddressFields = .PostalAddress
        
        // Display the view controller.
        let viewController = PKPaymentAuthorizationViewController(paymentRequest: paymentRequest)
        viewController.delegate = self
        presentViewController(viewController, animated: true, completion: nil)
    }
    
    
    // A function to generate our payment summary items, applying an international surcharge if required.
    func makeSummaryItems(requiresInternationalSurcharge requiresInternationalSurcharge: Bool) -> [PKPaymentSummaryItem] {
        var items = [PKPaymentSummaryItem]()
        
        /*
        Product items have a label (a string) and an amount (NSDecimalNumber).
        NSDecimalNumber is a Cocoa class that can express floating point numbers
        in Base 10, which ensures precision. It can be initialized with a
        double, or in this case, a string.
        */
        let productSummaryItem = PKPaymentSummaryItem(label: "Sub-total", amount: NSDecimalNumber(string: "0.99"))
        items += [productSummaryItem]
        
        let totalSummaryItem = PKPaymentSummaryItem(label: "Emporium", amount: productSummaryItem.amount)
        // Apply an international surcharge, if needed.
        
        items += [totalSummaryItem]
        
        return items
    }
    
    
    // MARK: - PKPaymentAuthorizationViewControllerDelegate
    
    /*
    Whenever the user changed their shipping information we will receive a
    callback here.
    
    Note that for privacy reasons the contact we receive will be redacted,
    and only have a city, ZIP, and country.
    
    You can use this method to estimate additional shipping charges and update
    the payment summary items.
    */
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didSelectShippingContact contact: PKContact, completion: (PKPaymentAuthorizationStatus, [PKShippingMethod], [PKPaymentSummaryItem]) -> Void) {
        
        /*
        Create a shipping method. Shipping methods use PKShippingMethod,
        which inherits from PKPaymentSummaryItem. It adds a detail property
        you can use to specify information like estimated delivery time.
        */
        let shipping = PKShippingMethod(label: "Standard Shipping", amount: NSDecimalNumber.zero())
        shipping.detail = "Delivers within two working days"
        
        /*
        Note that this is a contrived example. Because addresses can come from
        many sources on iOS they may not always have the fields you want.
        Your application should be sure to verify the address is correct,
        and return the appropriate status. If the address failed to pass validation
        you should return `.InvalidShippingPostalAddress` instead of `.Success`.
        */
        
        let address = contact.postalAddress
        let requiresInternationalSurcharge = address!.country != "United States"
        
        let summaryItems = makeSummaryItems(requiresInternationalSurcharge: requiresInternationalSurcharge)
        
        completion(.Success, [shipping], summaryItems)
    }
    
    /*
    This is where you would send your payment to be processed - here we will
    simply present a confirmation screen. If your payment processor failed the
    payment you would return `completion(.Failure)` instead. Remember to never
    attempt to decrypt the payment token on device.
    */
    func paymentAuthorizationViewController(controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: PKPaymentAuthorizationStatus -> Void) {
        
        JudoKit.applePayPayment(judoID, amount: Amount("0.99", "GBP"), reference: reference, payment: payment) { (response, error) -> () in
            if let _ = error {
                completion(.Failure)
            } else {
                completion(.Success)
            }
        }
        
    }
    
    func paymentAuthorizationViewControllerDidFinish(controller: PKPaymentAuthorizationViewController) {
        // We always need to dismiss our payment view controller when done.
        dismissViewControllerAnimated(true, completion: nil)
    }

}

