//
//  DetailViewController.swift
//  JudoPayDemoSwift
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
import JudoKit

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
