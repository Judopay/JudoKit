//
//  UIColor+Judo.swift
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

import Foundation


public extension UIColor {
    
    public static func judoDarkGrayColor() -> UIColor {
        return UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1.0)
    }
    
    public static func judoLightGrayColor() -> UIColor {
        return UIColor(red: 180/255, green: 180/255, blue: 180/255, alpha: 1.0)
    }
    
    public static func judoGrayColor() -> UIColor {
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
    }
    
    public static func judoButtonColor() -> UIColor {
        return UIColor(red: 30/255, green: 120/255, blue: 160/255, alpha: 1.0)
    }

    public static func judoButtonTitleColor() -> UIColor {
        return .whiteColor()
    }

    public static func judoLoadingBackgroundColor() -> UIColor {
        return UIColor(red: 210/255, green: 210/255, blue: 210/255, alpha: 0.8)
    }
    
    public static func judoRedColor() -> UIColor {
        return UIColor(red: 235/255, green: 55/255, blue: 45/255, alpha: 1.0)
    }
    
    public static func judoLoadingBlockViewColor() -> UIColor {
        return .whiteColor()
    }
    
    public static func judoInputFieldBackgroundColor() -> UIColor {
        return .whiteColor()
    }
    
}
