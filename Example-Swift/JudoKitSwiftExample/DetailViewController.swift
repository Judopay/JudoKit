//
//  DetailViewController.swift
//  JudoPayDemoSwift
//
//  Created by Hamon Riazy on 13/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo

class DetailViewController: UIViewController {
    
    @IBOutlet var dateStampLabel: UILabel!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var resolutionLabel: UILabel!
    
    var response: Response?
    
    let inputDateFormatter: NSDateFormatter = {
        let inputDateFormatter = NSDateFormatter()
        let enUSPOSIXLocale = NSLocale(localeIdentifier: "en_US_POSIX")
        inputDateFormatter.locale = enUSPOSIXLocale
        inputDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSZZZZZ"
        return inputDateFormatter
    }()
    
    let outputDateFormatter: NSDateFormatter = {
        let outputDateFormatter = NSDateFormatter()
        outputDateFormatter.dateFormat = "yyyy-MM-dd, HH:mm"
        return outputDateFormatter
    }()
    
    let currencyFormatter: NSNumberFormatter = {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Payment receipt"
        self.navigationItem.hidesBackButton = true
        
        if let response = self.response, let transaction = response.items.first {
            self.dateStampLabel.text = self.outputDateFormatter.stringFromDate(transaction.createdAt)
            self.currencyFormatter.currencyCode = transaction.amount.currency.rawValue
            self.amountLabel.text = transaction.amount.amount.stringValue + " " + transaction.amount.currency.rawValue
            self.resolutionLabel.text = transaction.result.rawValue
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let response = self.response, let transaction = response.items.first {
            self.dateStampLabel.text = self.outputDateFormatter.stringFromDate(transaction.createdAt)
            self.currencyFormatter.currencyCode = transaction.amount.currency.rawValue
            self.amountLabel.text = transaction.amount.amount.stringValue + " " + transaction.amount.currency.rawValue
        }
    }
    
    @IBAction func homeButtonHandler(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
}
