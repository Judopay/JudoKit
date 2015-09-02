//
//  DateTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 01/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

public class DateTextField: UIView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let textField = UITextField()
    let datePicker = UIPickerView()
    
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/yyyy"
        return formatter
    }()
    
    private let currentYear = NSCalendar.currentCalendar().component(.Year, fromDate: NSDate())
    private let currentMonth = NSCalendar.currentCalendar().component(.Month, fromDate: NSDate())
    
    public var isStartDate: Bool = false
    
    
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
        self.datePicker.dataSource = self
        self.textField.inputView = self.datePicker
        
        let month = NSString(format: "%02i", currentMonth)
        let year = NSString(format: "%02i", currentYear - 2000)
        self.textField.text = "\(month)/\(year)"
       
        self.datePicker.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        
        self.addSubview(self.textField)
    }
    
    
    // MARK: UIPickerViewDataSource
    
    public func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    public func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? 12 : 11
    }
    
    
    // MARK: UIPickerViewDelegate
    
    public func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return NSString(format: "%02i", row + 1) as String
        case 1:
            return NSString(format: "%02i", (self.isStartDate ? currentYear - row : currentYear + row) - 2000) as String
        default:
            return nil
        }
    }
    
    public func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // need to use NSString because Precision String Format Specifier is easier this way
        if component == 0 {
            let month = NSString(format: "%02i", row + 1)
            let oldDateString = self.textField.text!
            let year = oldDateString.substringFromIndex(oldDateString.endIndex.advancedBy(-2))
            self.textField.text = "\(month)/\(year)"
        } else if component == 1 {
            let oldDateString = self.textField.text!
            let month = oldDateString.substringToIndex(oldDateString.startIndex.advancedBy(2))
            let year = NSString(format: "%02i", (self.isStartDate ? currentYear - row : currentYear + row) - 2000)
            self.textField.text = "\(month)/\(year)"
        }
    }
    
}
