//
//  BillingCountryInputField.swift
//  JudoKit
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

/**
 
 The BillingCountryInputField is an input field configured to select a billing country out of a selected set of countries that we currently support.
 
 */
open class BillingCountryInputField: JudoPayInputField {
    
    let countryPicker = UIPickerView()
    
    var selectedCountry: BillingCountry = .uk
    
    override func setupView() {
        super.setupView()

        self.countryPicker.delegate = self
        self.countryPicker.dataSource = self
        
        self.textField.placeholder = " "
        self.textField.text = "UK"
        self.textField.inputView = self.countryPicker
        
        self.setActive(true)
    }
    
    
    // MARK: UITextFieldDelegate Methods
    
    /**
    Delegate method implementation
    
    - parameter textField: Text field
    - parameter range:     Range
    - parameter string:    String
    
    - returns: boolean to change characters in given range for a text field
    */
    open func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    // MARK: JudoInputType
    
    
    /**
    Check if this inputField is valid
    
    - returns: true if valid input
    */
    open override func isValid() -> Bool {
        return true
    }
    
    
    /**
     Title of the receiver inputField
     
     - returns: a string that is the title of the receiver
     */
    open override func title() -> String {
        return "Billing country"
    }
    
    
    /**
     Width of the title
     
     - returns: width of the title
     */
    open override func titleWidth() -> Int {
        return 120
    }
    
}

// MARK: UIPickerViewDataSource

extension BillingCountryInputField: UIPickerViewDataSource {
    
    /**
     Datasource method for billingCountryPickerView
     
     - parameter pickerView: PickerView that calls its delegate
     
     - returns: the number of components in the pickerView
     */
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    /**
     Datasource method for billingCountryPickerView
     
     - parameter pickerView: Picker view
     - parameter component:  A given component
     
     - returns: number of rows in component
     */
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return BillingCountry.allValues.count
    }
    
}

extension BillingCountryInputField: UIPickerViewDelegate {
    
    // MARK: UIPickerViewDelegate
    
    /**
    Delegate method for billingCountryPickerView
    
    - parameter pickerView: The caller
    - parameter row:        The row
    - parameter component:  The component
    
    - returns: title of a given component and row
    */
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return BillingCountry.allValues[row].title()
    }
    
    
    /**
     Delegate method for billingCountryPickerView that had a given row in a component selected
     
     - parameter pickerView: The caller
     - parameter row:        The row
     - parameter component:  The component
     */
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountry = BillingCountry.allValues[row]
        self.textField.text = self.selectedCountry.title()
        self.delegate?.billingCountryInputDidEnter(self, billingCountry: self.selectedCountry)
    }
}
