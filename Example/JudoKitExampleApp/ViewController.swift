//
//  ViewController.swift
//  JudoPayDemoSwift
//
//  Created by Hamon Riazy on 13/07/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo
import JudoKit

enum TableViewContent : Int {
    case Payment = 0, PreAuth, CreateCardToken, RepeatPayment, TokenPreAuth
    
    static func count() -> Int {
        return 5
    }
    
    func title() -> String {
        switch self {
        case .Payment:
            return "Make a payment"
        case .PreAuth:
            return "Make a preAuth"
        case .CreateCardToken:
            return "Create card token"
        case .RepeatPayment:
            return "Make a repeat payment"
        case .TokenPreAuth:
            return "Make a repeat token"
        }
    }
    
    func subtitle() -> String {
        switch self {
        case .Payment:
            return "with default settings"
        case .PreAuth:
            return "to reserve funds on a card"
        case .CreateCardToken:
            return "to be stored for future transactions"
        case .RepeatPayment:
            return "with a stored card token"
        case .TokenPreAuth:
            return "with a stored card token"
        }
    }
    
}

let judoID              = "<#YOUR JUDO-ID#>"
let tokenPayReference   = "<#YOUR REFERENCE#>"


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let kCellIdentifier = "com.judo.judopaysample.tableviewcellidentifier"
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var settingsViewBottomConstraint: NSLayoutConstraint!
    
    var cardDetails: CardDetails?
    var paymentToken: PaymentToken?
    
    var alertController: UIAlertController?
    
    var currentCurrency: String = "GBP"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = UIColor.clearColor()
        
        self.tableView.tableFooterView = {
            let view = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 50))
            let label = UILabel(frame: CGRectMake(15, 15, self.view.bounds.size.width - 30, 50))
            label.numberOfLines = 2
            label.text = "To view test card details:\nSign in to judo and go to Developer/Tools."
            label.font = UIFont.systemFontOfSize(12.0)
            label.textColor = UIColor.grayColor()
            view.addSubview(label)
            return view
            }()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if let alertController = self.alertController {
            self.presentViewController(alertController, animated: true, completion: nil)
            self.alertController = nil
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Actions
    
    @IBAction func settingsButtonHandler(sender: AnyObject) {
        if self.settingsViewBottomConstraint.constant != 0 {
            self.view.layoutIfNeeded()
            self.settingsViewBottomConstraint.constant = 0.0
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tableView.alpha = 0.2
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func settingsButtonDismissHandler(sender: AnyObject) {
        if self.settingsViewBottomConstraint.constant == 0 {
            self.view.layoutIfNeeded()
            self.settingsViewBottomConstraint.constant = -190
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.tableView.alpha = 1.0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func segmentedControlValueChange(segmentedControl: UISegmentedControl) {
        if let selectedIndexTitle = segmentedControl.titleForSegmentAtIndex(segmentedControl.selectedSegmentIndex) {
            self.currentCurrency = selectedIndexTitle
        }
    }
    
    @IBAction func AVSValueChanged(theSwitch: UISwitch) {
        JudoKit.sharedInstance.avsEnabled = theSwitch.on
    }
    
    // TODO: need to think of a way to add or remove certain card type acceptance as samples
    
    // MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewContent.count()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(ViewController.kCellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = TableViewContent(rawValue: indexPath.row)?.title()
        cell.detailTextLabel?.text = TableViewContent(rawValue: indexPath.row)?.subtitle()
        return cell
    }
    
    
    // MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        guard let value = TableViewContent(rawValue: indexPath.row) else {
            return
        }
        
        switch value {
        case .Payment:
            paymentOperation()
        case .PreAuth:
            preAuthOperation()
        case .CreateCardToken:
            createCardTokenOperation()
        case .RepeatPayment:
            repeatPaymentOperation()
        case .TokenPreAuth:
            repeatPreAuthOperation()
        }
    }
    
    // MARK: Operations
    
    func paymentOperation() {
        JudoKit.sharedInstance.payment(judoID, amount: Amount(35.0, currentCurrency), reference: Reference(yourConsumerReference: "payment reference", yourPaymentReference: "consumer reference"), completion: { (response, error) -> () in
            if let _ = error {
                self.alertController = UIAlertController(title: "Error", message: "there was an error performing the operation", preferredStyle: .Alert)
                self.alertController!.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                return // BAIL
            }
            if let resp = response, transactionData = resp.items.first {
                self.cardDetails = transactionData.cardDetails
                self.paymentToken = transactionData.paymentToken()
            }
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let viewController = sb.instantiateViewControllerWithIdentifier("detailviewcontroller") as! DetailViewController
            viewController.response = response
            self.navigationController?.pushViewController(viewController, animated: true)
        })
    }
    
    func preAuthOperation() {
        JudoKit.sharedInstance.preAuth(judoID, amount: Amount(40, currentCurrency), reference: Reference(yourConsumerReference: "payment reference", yourPaymentReference: "consumer reference"), completion: { (response, error) -> () in
            if let _ = error {
                self.alertController = UIAlertController(title: "Error", message: "there was an error performing the operation", preferredStyle: .Alert)
                self.alertController!.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                return // BAIL
            }
            if let resp = response, transactionData = resp.items.first {
                self.cardDetails = transactionData.cardDetails
                self.paymentToken = transactionData.paymentToken()
            }
            let sb = UIStoryboard(name: "Main", bundle: nil)
            let viewController = sb.instantiateViewControllerWithIdentifier("detailviewcontroller") as! DetailViewController
            viewController.response = response
            self.navigationController?.pushViewController(viewController, animated: true)
        })
    }
    
    func createCardTokenOperation() {
        JudoKit.sharedInstance.registerCard(judoID, amount: Amount(1), reference: Reference(yourConsumerReference: "payment reference", yourPaymentReference: "consumer reference"), completion: { (response, error) -> () in
            if let _ = error {
                self.alertController = UIAlertController(title: "Error", message: "there was an error performing the operation", preferredStyle: .Alert)
                self.alertController!.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                return // BAIL
            }
            if let resp = response, transactionData = resp.items.first {
                self.cardDetails = transactionData.cardDetails
                self.paymentToken = transactionData.paymentToken()
            }
        })
    }
    
    func repeatPaymentOperation() {
        if let cardDetails = self.cardDetails, let payToken = self.paymentToken {
            JudoKit.sharedInstance.tokenPayment(judoID, amount: Amount(30), reference: Reference(yourConsumerReference: "payment reference", yourPaymentReference: "consumer reference"), cardDetails: cardDetails, paymentToken: payToken, completion: { (response, error) -> () in
                if let _ = error {
                    self.alertController = UIAlertController(title: "Error", message: "there was an error performing the operation", preferredStyle: .Alert)
                    self.alertController!.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    return // BAIL
                }
                if let resp = response, transactionData = resp.items.first {
                    self.cardDetails = transactionData.cardDetails
                    self.paymentToken = transactionData.paymentToken()
                }
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let viewController = sb.instantiateViewControllerWithIdentifier("detailviewcontroller") as! DetailViewController
                viewController.response = response
                self.navigationController?.pushViewController(viewController, animated: true)
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "you need to create a card token before making a repeat payment or preauth operation", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func repeatPreAuthOperation() {
        if let cardDetails = self.cardDetails, let payToken = self.paymentToken {
            JudoKit.sharedInstance.tokenPreAuth(judoID, amount: Amount(30), reference: Reference(yourConsumerReference: "payment reference", yourPaymentReference: "consumer reference"), cardDetails: cardDetails, paymentToken: payToken, completion: { (response, error) -> () in
                if let _ = error {
                    self.alertController = UIAlertController(title: "Error", message: "there was an error performing the operation", preferredStyle: .Alert)
                    self.alertController!.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                    return // BAIL
                }
                if let resp = response, transactionData = resp.items.first {
                    self.cardDetails = transactionData.cardDetails
                    self.paymentToken = transactionData.paymentToken()
                }
                let sb = UIStoryboard(name: "Main", bundle: nil)
                let viewController = sb.instantiateViewControllerWithIdentifier("detailviewcontroller") as! DetailViewController
                viewController.response = response
                self.navigationController?.pushViewController(viewController, animated: true)
            })
        } else {
            let alert = UIAlertController(title: "Error", message: "you need to create a card token before making a repeat payment or preauth operation", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
