//
//  DateTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 01/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

let maximumCardValidity = 60 * 60 * 24 * 365 * 10 // a Credit Card can be valid up to ten years

public class DateTextField: UIView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let textField = UITextField()
    let datePicker = UIPickerView()
    
    let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        return formatter
    }()
    
    // MARK: Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        // set up the textfield
        self.textField.frame = self.frame
        self.textField.delegate = self
        
        // input method should be via date picker
        self.datePicker.delegate = self
        self.textField.inputView = self.datePicker
        
        self.addSubview(self.textField)
    }
     
    // MARK: UIPickerViewDataSource
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 12 : 10
    }
    
    func viewForRow(row: Int, forComponent component: Int) -> UIView? {
        return nil
    }
    
}
