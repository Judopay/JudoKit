//
//  HintLabel.swift
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

/// Label that sits below the payment entry form, showing alerts and hints
public class HintLabel: UILabel {
    /// The alert text if an alert occured
    var alertText: NSAttributedString?
    /// The hint text if a hint is being shown
    var hintText: NSAttributedString?
    /// the theme of the current session
    let theme: Theme
    
    
    /**
     designated initializer
     
     - parameter currentTheme: the theme for the HintLabel UI
     
     - returns: a HintLabel instance
     */
    public init(currentTheme: Theme) {
        self.theme = currentTheme
        super.init(frame: CGRectZero)
    }
    
    
    /**
     required initializer
     
     - parameter aDecoder: a decoder
     
     - returns: a HintLabel instance
     */
    required convenience public init(coder aDecoder: NSCoder) {
        self.init(currentTheme: Theme())
    }
    
    
    /**
     a function that will return true if any of the texts is set
     */
    public func isActive() -> Bool {
        return alertText?.length > 0 || hintText?.length > 0
    }
    
    
    /**
     Makes the hint text visible in case there is no alert text occupying the space
     
     - parameter text: The hint text string to show
     */
    public func showHint(text: String) {
        self.hintText = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:self.theme.judoDarkGrayColor()])
        if self.alertText == nil {
            self.addAnimation()
            
            self.attributedText = self.hintText
        }
    }
    
    
    /**
     Makes the alert text visible and overrides the hint text if it has been previously set and visible at the current time
     
     - parameter text: The alert text string to show
     */
    public func showAlert(text: String) {
        self.addAnimation()
        
        self.alertText = NSAttributedString(string: text, attributes: [NSForegroundColorAttributeName:UIColor.redColor()])
        self.attributedText = self.alertText
    }
    
    
    /**
    Hide the currently visible hint text and show the alert text if available
     */
    public func hideHint() {
        self.addAnimation()
        
        self.hintText = nil
        self.attributedText = self.alertText
    }
    
    
    /**
     Hide the currently visible alert text and show the hint text if available
     */
    public func hideAlert() {
        self.addAnimation()
        
        self.alertText = nil
        self.attributedText = self.hintText
    }
    
    
    /**
     Helper to show/hide/transition between texts
     */
    public func addAnimation() {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = kCATransitionFade
        animation.duration = 0.5
        self.layer.addAnimation(animation, forKey: "kCATransitionFade")
    }
    
}
