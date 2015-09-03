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
        let cardTextField = CardTextField(frame: CGRectMake(0, 0, 280, 44))
        let dateTextField = DateTextField(frame: CGRectMake(0, 0, 140, 44))
        let secTextField = SecurityTextField(frame: CGRectMake(0, 0, 140, 44))

        cardTextField.layer.borderColor = UIColor.grayColor().CGColor
        cardTextField.layer.borderWidth = 1.0
        self.view.addSubview(cardTextField)
        cardTextField.center = CGPointMake(self.view.center.x, self.view.center.y - 44)
        
        dateTextField.layer.borderColor = UIColor.grayColor().CGColor
        dateTextField.layer.borderWidth = 1.0
        self.view.addSubview(dateTextField)
        dateTextField.center = CGPointMake(self.view.center.x - 70, self.view.center.y)
        
        secTextField.layer.borderColor = UIColor.grayColor().CGColor
        secTextField.layer.borderWidth = 1.0
        self.view.addSubview(secTextField)
        secTextField.center = CGPointMake(self.view.center.x + 70, self.view.center.y)
        
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

 