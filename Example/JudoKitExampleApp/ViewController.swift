//
//  ViewController.swift
//  JudoKitExampleApp
//
//  Created by Hamon Riazy on 14/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import JudoKit
import Judo

let strippedJudoID = "100963875"

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(type: .RoundedRect)
        button.frame = CGRectMake(0, 0, 140, 44)
        button.setTitle("Simple Payment", forState: .Normal)
        button.addTarget(self, action: Selector("startPaymentJourney"), forControlEvents: .TouchUpInside)
        button.center = self.view.center
        self.view.addSubview(button)
    }
    
    func startPaymentJourney() {
        JudoKit.payment(strippedJudoID, amount: Amount(30), reference: Reference(yourConsumerReference: "consumerRef", yourPaymentReference: "paymentRef"), viewController: self)
    }

}
