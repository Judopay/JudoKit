//
//  ViewController.swift
//  JudoKitExampleApp
//
//  Created by Hamon Riazy on 14/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import JudoKit

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
        let vc = JPayViewController.payment()
        self.presentViewController(vc, animated: true, completion: nil)
    }

}

