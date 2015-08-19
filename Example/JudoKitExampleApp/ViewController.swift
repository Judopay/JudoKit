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
        let textField = JKTextField()
        textField.layer.borderColor = UIColor.grayColor().CGColor
        textField.layer.borderWidth = 1.0
        self.view.addSubview(textField)
        textField.center = self.view.center
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func tapButton() {
        JudoKit.someMethod()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

