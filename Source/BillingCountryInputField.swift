//
//  BillingCountryInputField.swift
//  JudoKit
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
import Judo


/**
 
 The BillingCountryInputField is an input field configured to select a billing country out of a selected set of countries that we currently support.
 
 */
public class BillingCountryInputField: JudoPayInputField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let countryPicker = UIPickerView()
    
    var selectedCountry: BillingCountry = .UK
    
    override func setupView() {
        super.setupView()

        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        
        self.textField().text = "UK"
        self.textField().inputView = self.countryPicker
        
        self.setActive(true)
    }
    
    override func title() -> String {
        return "Billing country"
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
        return BillingCountry.allValues[row].title()
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = BillingCountry.allValues[row]
        self.textField().text = self.selectedCountry.title()
        self.delegate?.billingCountryInputDidEnter(self, billingCountry: self.selectedCountry)
    }
    
}
