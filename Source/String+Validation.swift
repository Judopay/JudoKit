//
//  String+Validation.swift
//  Judo
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

import Foundation


public extension String {
    
    
    /// String by stripping all whitespaces
    public var strippedWhitespaces: String {
        get {
            return self.replacingOccurrences(of: " ", with: "")
        }
        set {
            // do nothing
        }
    }
    
    
    /// String by stripping all non-digit characters
    public var stripped: String {
        get {
            if self.isNumeric() {
                return self
            } else {
                return self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
            }
        }
        set {
            // do nothing
        }
    }
    
    
    /// String by stripping commas
    public var strippedCommas: String {
        get {
            return self.replacingOccurrences(of: ",", with: "")
        }
        set {
            // do nothing
        }
    }
    
    /**
     Method to check if a string is Luhn valid
     
     - returns: true if given string is Luhn valid
     */
    public func isLuhnValid() -> Bool {
        guard self.isNumeric() else {
            return false
        }
        let reversedInts = self.characters.reversed().map { Int(String($0)) }
        return reversedInts.enumerated().reduce(0) { (sum, val) in
            let odd = val.offset % 2 == 1
            return sum + (odd ? (val.element! == 9 ? 9 : (val.element! * 2) % 9) : val.element!)
            } % 10 == 0
    }
    
    
    /**
     Method to check whether string contains only numbers and letters
     
     - returns: true if string consists of numbers and letters
     */
    public func isAlphaNumeric() -> Bool {
        let nonAlphaNum = CharacterSet.alphanumerics.inverted
        return self.rangeOfCharacter(from: nonAlphaNum) == nil
    }
    
    /**
     Method to check whether string contains only numbers and letters
     
     - returns: true if string consists of numbers and letters
     */
    public func isNumeric() -> Bool {
        return Double(self) != nil
    }
    
}
