//
//  PrimaryCardSwitch.swift
//  JudoKit
//
//  Copyright (c) 2017 Alternative Payments Ltd
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

open class PrimaryCardSwitch: UIView {
    
    /// the theme of the current judoKit session
    open var theme: Theme
    
    let titleLabel = UILabel()
    let primarySwitch = UISwitch()
    
    let redBlock = UIView()
    
    // MARK: Initializers
    
    /**
     Designated Initializer for PrimaryCardSwitch
     
     - parameter theme: the theme to use
     
     - returns: a PrimaryCardSwitch instance
     */
    public init(theme: Theme) {
        self.theme = theme
        super.init(frame: CGRect.zero)
        self.setupView()
    }
    
    /**
     Designated Initializer for PrimaryCardSwitch
     
     - parameter frame: the frame of the input view
     
     - returns: a PrimaryCardSwitch instance
     */
    override public init(frame: CGRect) {
        self.theme = Theme()
        super.init(frame: CGRect.zero)
        self.setupView()
    }
    
    /**
     Required initializer set as convenience to trigger the designated initializer that contains all necessary initialization methods
     
     - parameter aDecoder: decoder is ignored
     
     - returns: a PrimaryCardSwitch instance
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRect.zero)
    }
    
    /**
     Helper method to initialize the view
     */
    func setupView() {
        self.redBlock.backgroundColor = self.theme.getErrorColor()
        self.redBlock.autoresizingMask = .flexibleWidth
        self.redBlock.translatesAutoresizingMaskIntoConstraints = false
        
        self.backgroundColor = self.theme.getInputFieldBackgroundColor()
        self.clipsToBounds = true
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.primarySwitch.translatesAutoresizingMaskIntoConstraints = false
        self.primarySwitch.onTintColor = self.theme.getButtonColor()
        self.titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        self.titleLabel.textColor = .black
        self.titleLabel.text = "Make primary card"
        
        self.addSubview(self.titleLabel)
        self.addSubview(self.primarySwitch)
        self.addSubview(self.redBlock)
        
        //Setup constraints
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[label(40)]-1-|", options: .alignAllLastBaseline, metrics: nil, views: ["label":self.titleLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[switch]-5-|", options: .alignAllLastBaseline, metrics: nil, views: ["switch": primarySwitch]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-15-[label(width)][switch]-15-|", options: .directionLeftToRight, metrics: ["width": UIScreen.main.bounds.size.width - primarySwitch.frame.size.width - 30], views: ["label":self.titleLabel, "switch": primarySwitch]))
        
        redBlockAsActive()
    }
    
    func  redBlockAsActive() {
        self.setRedBlockFrameAndBackgroundColor(height: 0.5, backgroundColor: self.theme.getInputFieldBorderColor().withAlphaComponent(1.0))
    }
    
    private  func setRedBlockFrameAndBackgroundColor(height: CGFloat, backgroundColor: UIColor) {
        self.redBlock.backgroundColor = backgroundColor
        let yPosition:CGFloat = self.frame.size.height == 50 ? 4 : 22;
        self.redBlock.frame = CGRect(x: 13.0, y: self.frame.size.height - yPosition, width: self.frame.size.width - 26.0, height: height)
    }
    
}
