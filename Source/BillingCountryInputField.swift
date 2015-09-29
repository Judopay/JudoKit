//
//  BillingCountryInputField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 09/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo

public class BillingCountryInputField: JudoPayInputField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let countryPicker = UIPickerView()
    
    var selectedCountry: BillingCountry = .UK
    
    override func setupView() {
        super.setupView()

        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        
        self.textField.text = "UK"
        self.textField.inputView = self.countryPicker
        
        self.setActive(true)
    }
    
    override func title() -> String {
        return "Billing Country"
    }
    
    override func titleWidth() -> Int {
        return 120
    }
    
    // MARK: UITextFieldDelegate Methods
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    
    // MARK: UIPickerViewDataSource
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BillingCountry.allValues.count
    }
    
    
    // MARK: UIPickerViewDelegate
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BillingCountry.allValues[row].rawValue
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = BillingCountry.allValues[row]
        self.textField.text = self.selectedCountry.rawValue
        self.delegate?.billingCountryInputDidEnter(self, billingCountry: self.selectedCountry)
    }
    
}
