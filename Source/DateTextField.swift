//
//  DateTextField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 01/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit
import Judo

public protocol DateTextFieldDelegate {
    func dateTextField(textField: DateTextField, error: ErrorType)
    func dateTextField(textField: DateTextField, didFindValidDate date: String)
}


/**
The DateTextField allows two different modes of input.

- Picker: use a custom UIPickerView with month and year fields
- Text:   use a common Numpad Keyboard as text input method
*/
public enum DateInputType {
    case Picker, Text
}

public class DateTextField: JudoPayInputField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let datePicker = UIPickerView()
    
    public var delegate: DateTextFieldDelegate?

    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter
    }()
    
    private let currentYear = NSCalendar.currentCalendar().component(.Year, fromDate: NSDate())
    private let currentMonth = NSCalendar.currentCalendar().component(.Month, fromDate: NSDate())
    
    public var isStartDate: Bool = false
    
    public var dateInputType: DateInputType = .Text {
        didSet {
            switch dateInputType {
            case .Picker:
                self.textField.inputView = self.datePicker
                let month = NSString(format: "%02i", currentMonth)
                let year = NSString(format: "%02i", currentYear - 2000)
                self.textField.text = "\(month)/\(year)"
                self.datePicker.selectRow(currentMonth - 1, inComponent: 0, animated: false)
                break
            case .Text:
                self.textField.inputView = nil
                self.textField.keyboardType = .NumberPad
            }
        }
    }
    
    
    // MARK: Initializers
    
    override func setupView() {
        super.setupView()
        
        self.titleLabel.text = "Expiry"
        
        // input method should be via date picker
        self.datePicker.delegate = self
        self.datePicker.dataSource = self
        
        switch self.dateInputType {
        case .Picker:
            self.textField.inputView = self.datePicker
            let month = NSString(format: "%02i", currentMonth)
            let year = NSString(format: "%02i", currentYear - 2000)
            self.textField.text = "\(month)/\(year)"
            self.datePicker.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        case .Text:
            self.textField.keyboardType = .NumberPad
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // only handle calls if textinput is selected
        guard self.dateInputType == .Text else { return true }
        
        // only handle delegate calls for own textfield
        guard textField == self.textField else { return true }
        
        // get old and new text
        let oldString = textField.text!
        let newString = (oldString as NSString).stringByReplacingCharactersInRange(range, withString: string)
        
        if newString.characters.count == 0 {
            return true
        } else if newString.characters.count == 1 {
            return newString == "0" || newString == "1"
        } else if newString.characters.count == 2 {
            // if deletion is handled and user is trying to delete the month no slash should be added
            guard string.characters.count > 0 else {
                return true
            }
            
            guard Int(newString) > 0 && Int(newString) <= 12 else {
                return false
            }
            
            self.textField.text = newString + "/"
            return false

        } else if newString.characters.count == 3 {
            return newString.characters.last == "/"
        } else if newString.characters.count == 4 {
            // FIXME: need to make sure that number is numeric
            let deciYear = Int((Double(NSCalendar.currentCalendar().component(.Year, fromDate: NSDate()) - 2000) / 10.0))
            let lastChar = Int(String(newString.characters.last!))
            
            if self.isStartDate {
                return lastChar == deciYear || lastChar == deciYear - 1
            } else {
                return lastChar == deciYear || lastChar == deciYear + 1
            }
            
        } else if newString.characters.count == 5 {
            let date = self.dateFormatter.dateFromString(newString)
            if self.isStartDate {
                if date?.compare(NSDate()) == .OrderedDescending {
                    // FIXME: not a good solution - need to think of something better
                    // Delegate calls result in the next textfield being selected before the actual input can be processed
                    self.textField.text = newString
                    self.delegate?.dateTextField(self, didFindValidDate: newString)
                    return false
                } else {
                    self.delegate?.dateTextField(self, error: JudoError.InvalidEntry)
                    return false
                }
            } else {
                if date?.compare(NSDate()) != .OrderedAscending {
                    // FIXME: not a good solution - need to think of something better
                    // Delegate calls result in the next textfield being selected before the actual input can be processed
                    self.textField.text = newString
                    self.delegate?.dateTextField(self, didFindValidDate: newString)
                    return false
                } else {
                    self.delegate?.dateTextField(self, error: JudoError.InvalidEntry)
                    return false
                }
            }
        } else {
            self.delegate?.dateTextField(self, error: JudoError.InputLengthMismatchError)
            return false
//            let regex = try! NSRegularExpression(pattern: "^(0[1-9]|1[0-2])(\\/[0-9]{0,2})?$", options: .AnchorsMatchLines)
//            return regex.numberOfMatchesInString(newString, options: NSMatchingOptions.WithoutAnchoringBounds, range: NSMakeRange(0, newString.characters.count)) > 0
        }
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
