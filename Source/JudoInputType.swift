//
//  JudoInputType.swift
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

import Foundation

/**
 *  The type for all the input fields to conform to
 */
public protocol JudoInputType {
    /**
     Helper method for the hintLabel to disappear or reset the timer when called. This is triggered by the `shouldChangeCharactersInRange:` method in each of the `inputField` subclasses
     */
    func didChangeInputText()
    
    
    /**
     Method that is called after a value has changed. This method is intended for subclassing.
     
     - parameter textField: the `UITextField` that has a changed value
     */
    func textFieldDidChangeValue(textField: UITextField)
    
    
    /**
     Placeholder string for text fields depending on layout configuration. This method is intended for subclassing.
     
     - returns: an NSAttributedString depending on color and configuration
     */
    func placeholder() -> NSAttributedString?
    
    
    /**
     An indication of whether an input field contains a Logo or not. This method is intended for subclassing.
     
     - returns: a boolean indication whether logo should be shown
     */
    func containsLogo() -> Bool
    
    
    /**
     The logo of an input field if available. This method is intended for subclassing.
     
     - returns: the logo of an inputField
     */
    func logoView() -> CardLogoView?
    
    
    /**
     The title of an input field. This method is intended for subclassing.
     
     - returns: the title of an inputField
     */
    func title() -> String
 
    
    /**
     The title width for a given title and input field. This method is intended for subclassing.
     
     - returns: a title width in integer
     */
    func titleWidth() -> Int
    
    
    /**
     A hint text for a given input field. This method is intended for subclassing.
     
     - returns: a String with instructions for a given inputField that pops up after 3 seconds of being idle
     */
    func hintLabelText() -> String
    
    
    /**
     A function that replies whether the entered text in that specific field is valid or not.
     
     - returns: true if information in field is valid
     */
    func isValid() -> Bool
}
