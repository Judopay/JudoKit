//
//  ViewController.swift
//  JudoKitExampleApp
//
//  Created by Hamon Riazy on 14/08/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo
import JudoKit

class ViewController: UIViewController, CardTextFieldDelegate {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let textField = DateTextField(frame: CGRectMake(0, 0, 240, 44))
//        textField.dateInputType = .Picker
//        textField.delegate = self
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 1.0
        self.view.addSubview(textField)
        textField.center = self.view.center
        
//        textField.acceptedCardNetworks = [Card.Configuration(.ChinaUnionPay, 19),
//            Card.Configuration(.ChinaUnionPay, 16)]
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cardTextField(textField: CardTextField, error: ErrorType) {
        print("error happened")
    }
    
    func cardTextField(textField: CardTextField, didFindValidNumber cardNumberString: String) {
        print("did find valid number")
    }
    
    func cardTextField(textField: CardTextField, didDetectNetwork: CardNetwork) {
        print("did detect network")
    }

}

