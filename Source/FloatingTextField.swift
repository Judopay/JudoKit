//
//  FloatingTextField.swift
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

class FloatingTextField: UITextField {
    let animationDuration = 0.3
    var title = UILabel()
    let theme: Theme
    
    // MARK: - Properties
    override var accessibilityLabel: String! {
        get {
            if text!.isEmpty {
                return title.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    
    override var placeholder: String? {
        didSet {
            title.text = placeholder
            title.sizeToFit()
        }
    }
    
    override var attributedPlaceholder: NSAttributedString? {
        didSet {
            title.text = attributedPlaceholder?.string
            title.sizeToFit()
        }
    }
    
    var titleFont: UIFont = .systemFont(ofSize: 12.0) {
        didSet {
            title.font = titleFont
            title.sizeToFit()
        }
    }
    
    var keepBaseline = false
    
    var hintYPadding: CGFloat = 0.0
    
    var titleYPadding: CGFloat = 6.0 {
        didSet {
            var r = title.frame
            r.origin.y = titleYPadding
            title.frame = r
        }
    }
    
    var titleTextColour: UIColor = .gray {
        didSet {
            if !isFirstResponder {
                title.textColor = titleTextColour
            }
        }
    }
    
    var titleActiveTextColour: UIColor! {
        didSet {
            if isFirstResponder {
                title.textColor = titleActiveTextColour
            }
        }
    }
    
    // MARK: - Init
    init(currentTheme: Theme) {
        self.theme = currentTheme
        super.init(frame: CGRect.zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.theme = Theme()
        super.init(coder:aDecoder)
        setup()
    }
    
    override init(frame: CGRect) {
        self.theme = Theme()
        super.init(frame: frame)
        setup()
    }
    
    // MARK: - Overrides
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setTitlePositionForTextAlignment()
        let isResp = isFirstResponder
        if isResp && !text!.isEmpty {
            title.textColor = titleActiveTextColour
        } else {
            title.textColor = titleTextColour
        }
        // Should we show or hide the title label?
        if text!.isEmpty {
            // Hide
            hideTitle(isResp)
        } else {
            // Show
            showTitle(isResp)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var r = super.textRect(forBounds: bounds)
        if !text!.isEmpty || self.keepBaseline {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
        }
        return r.integral
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var r = super.editingRect(forBounds: bounds)
        if !text!.isEmpty || self.keepBaseline {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = UIEdgeInsetsInsetRect(r, UIEdgeInsetsMake(top, 0.0, 0.0, 0.0))
        }
        return r.integral
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        var r = super.clearButtonRect(forBounds: bounds)
        if !text!.isEmpty || self.keepBaseline {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
        }
        return r.integral
    }
    
    // MARK: - Private Methods
    
    fileprivate func setup() {
        borderStyle = UITextBorderStyle.none
        titleActiveTextColour = self.theme.getButtonColor()
        // Set up title label
        title.alpha = 0.0
        title.font = titleFont
        title.textColor = titleTextColour
        if let str = placeholder {
            if !str.isEmpty {
                title.text = str
                title.sizeToFit()
            }
        }
        self.addSubview(title)
    }
    
    fileprivate func maxTopInset() -> CGFloat {
        return max(0, floor(bounds.size.height - font!.lineHeight - 4.0))
    }
    
    fileprivate func setTitlePositionForTextAlignment() {
        let r = textRect(forBounds: bounds)
        var x = r.origin.x
        if textAlignment == NSTextAlignment.center {
            x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
        } else if textAlignment == NSTextAlignment.right {
            x = r.origin.x + r.size.width - title.frame.size.width
        }
        title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
    }
    
    fileprivate func showTitle(_ animated: Bool) {
        if self.title.alpha == 0.0 {
            let dur = animated ? animationDuration : 0
            UIView.animate(withDuration: dur, delay:0, options: UIViewAnimationOptions.beginFromCurrentState.union(UIViewAnimationOptions.curveEaseOut), animations:{
                // Animation
                self.title.alpha = 1.0
                var r = self.title.frame
                r.origin.y = self.titleYPadding
                self.title.frame = r
                }, completion:nil)
        }
    }
    
    fileprivate func hideTitle(_ animated: Bool) {
        if self.title.alpha == 1.0 {
            let dur = animated ? animationDuration : 0
            UIView.animate(withDuration: dur, delay:0, options: UIViewAnimationOptions.beginFromCurrentState.union(UIViewAnimationOptions.curveEaseIn), animations:{
                // Animation
                self.title.alpha = 0.0
                var r = self.title.frame
                r.origin.y = self.title.font.lineHeight + self.hintYPadding
                self.title.frame = r
                }, completion:nil)
        }
    }
}
