//
//  Payment.swift
//  Judo
//
//  Copyright (c) 2015 Alternative Payments Ltd
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

let inputFieldBorderColor = UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)

class JPayViewController: UIViewController {
    
    let paymentTextField: CardTextField = {
        let inputField = CardTextField()
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.layer.borderColor = inputFieldBorderColor.CGColor
        inputField.layer.borderWidth = 1.0
        return inputField
    }()
    
    let expiryDateTextField: DateTextField = {
        let inputField = DateTextField()
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.layer.borderColor = inputFieldBorderColor.CGColor
        inputField.layer.borderWidth = 1.0
        return inputField
    }()
    
    let secureCodeTextField: SecurityTextField = {
        let inputField = SecurityTextField()
        inputField.translatesAutoresizingMaskIntoConstraints = false
        inputField.layer.borderColor = inputFieldBorderColor.CGColor
        inputField.layer.borderWidth = 1.0
        return inputField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(paymentTextField)
        self.view.addSubview(expiryDateTextField)
        self.view.addSubview(secureCodeTextField)
        
        // TODO: Autolayout
    }
    
    
    
}
