//
//  PayButton.swift
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
 
 The PayButton is a button that is configured to layout a judo pay button for the transaction journey
 
 */
open class PayButton: UIButton {
    
    let theme: Theme
    
    // MARK: initialization
    
    /**
    Designated initializer
    
    - returns: A PayButton object
    */
    public init(currentTheme: Theme) {
        self.theme = currentTheme
        super.init(frame: CGRect.zero)
        self.setupView()
    }
    
    
    /**
     Convenience initializer
     
     - parameter frame: This value is ignored - view is sized via autolayout
     
     - returns: A PayButton object
     */
    convenience override public init(frame: CGRect) {
        self.init(currentTheme: Theme())
    }
    
    
    /**
     Convenience initializer
     
     - parameter aDecoder: Ignored parameter
     
     - returns: A PayButton object
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        self.init(currentTheme: Theme())
    }
    
    // MARK: View Setup
    
    /**
    Helper method to setup the view
    */
    open func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = self.theme.getButtonColor()
        self.setTitle("Pay", for: UIControlState())
        self.setTitleColor(self.theme.getButtonTitleColor(), for: UIControlState())
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
    }
    
}
