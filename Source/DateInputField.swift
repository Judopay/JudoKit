//
//  DateTextField.swift
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
The DateTextField allows two different modes of input.

- Picker: use a custom UIPickerView with month and year fields
- Text:   use a common Numpad Keyboard as text input method
*/
public enum DateInputType {
    case Picker, Text
}

public class DateInputField: JudoPayInputField, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let datePicker = UIPickerView()
    
    private let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "MM/yy"
        return formatter
    }()
    
    private let currentYear = NSCalendar.currentCalendar().component(.Year, fromDate: NSDate())
    private let currentMonth = NSCalendar.currentCalendar().component(.Month, fromDate: NSDate())
    
    public var isStartDate: Bool = false {
        didSet {
            if self.layoutType == .Aside {
                self.titleLabel.text = self.title()
            } else {
                self.textField().attributedPlaceholder = NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
            }
        }
    }
    
    public var dateInputType: DateInputType = .Text {
        didSet {
            switch dateInputType {
            case .Picker:
                self.textField().inputView = self.datePicker
                let month = NSString(format: "%02i", currentMonth)
                let year = NSString(format: "%02i", currentYear - 2000) // FIXME: not quite happy with this, must be a better way
                self.textField().text = "\(month)/\(year)"
                self.datePicker.selectRow(currentMonth - 1, inComponent: 0, animated: false)
                break
            case .Text:
                self.textField().inputView = nil
                self.textField().keyboardType = .NumberPad
            }
        }
    }
    
    
    // MARK: Initializers
    
    override func setupView() {
        super.setupView()
        
        // input method should be via date picker
        self.datePicker.delegate = self
        self.datePicker.dataSource = self
        
        switch self.dateInputType {
        case .Picker:
            self.textField().inputView = self.datePicker
            let month = NSString(format: "%02i", currentMonth)
            let year = NSString(format: "%02i", currentYear - 2000)
            self.textField().text = "\(month)/\(year)"
            self.datePicker.selectRow(currentMonth - 1, inComponent: 0, animated: false)
        case .Text:
            self.textField().keyboardType = .NumberPad
        }
    }
    
    
    // MARK: UITextFieldDelegate
    
    public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // only handle calls if textinput is selected
        guard self.dateInputType == .Text else { return true }
        
        // only handle delegate calls for own textfield
        guard textField == self.textField() else { return false }
        
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
            
            self.textField().text = newString + "/"
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
            return true
        } else {
            self.delegate?.dateInput(self, error: JudoError.InputLengthMismatchError)
            return false
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
            let oldDateString = self.textField().text!
            let year = oldDateString.substringFromIndex(oldDateString.endIndex.advancedBy(-2))
            self.textField().text = "\(month)/\(year)"
        } else if component == 1 {
            let oldDateString = self.textField().text!
            let month = oldDateString.substringToIndex(oldDateString.startIndex.advancedBy(2))
            let year = NSString(format: "%02i", (self.isStartDate ? currentYear - row : currentYear + row) - 2000)
            self.textField().text = "\(month)/\(year)"
        }
    }
    
    // MARK: Custom methods
    
    override func textFieldDidChangeValue(textField: UITextField) {
        super.textFieldDidChangeValue(textField)
        
        guard let text = textField.text where text.characters.count == 5 else { return }
        
        let date = self.dateFormatter.dateFromString(text)
        if self.isStartDate {
            if date?.compare(NSDate()) == .OrderedDescending {
                self.delegate?.dateInput(self, didFindValidDate: text)
            } else {
                self.delegate?.dateInput(self, error: JudoError.InvalidEntry)
            }
        } else {
            if date?.compare(NSDate()) != .OrderedAscending {
                self.delegate?.dateInput(self, didFindValidDate: text)
            } else {
                self.delegate?.dateInput(self, error: JudoError.InvalidEntry)
            }
        }
    }
    
    override func placeholder() -> NSAttributedString? {
        if self.layoutType == .Above {
            return NSAttributedString(string: self.title(), attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
        }
        return NSAttributedString(string: "MM/YY", attributes: [NSForegroundColorAttributeName:UIColor.judoLightGrayColor()])
    }
    
    override func title() -> String {
        var title = isStartDate ? "Start" : "Expiry"
        if self.layoutType == .Above {
            title += " date"
        }
        return title
    }

}
