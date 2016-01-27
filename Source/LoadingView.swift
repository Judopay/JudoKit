//
//  LoadingView.swift
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
 
 The LoadingView is a convenience class that is configured to show a block with a activityIndicator and a description text
 
 */
public class LoadingView: UIView {
    
    private let blockView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView()
    
    /// The label that shows a description text
    let actionLabel = UILabel()
    
    
    /**
     Designated initializer
     
     - returns: A LoadingView object
     */
    public init() {
        super.init(frame: CGRectZero)
        self.setupView()
    }
    
    
    /**
     Convenience initializer
     
     - parameter frame: This value is ignored - view is sized via autolayout
     
     - returns: a LoadingView object
     */
    convenience override public init(frame: CGRect) {
        self.init()
    }
    
    
    /**
     Convenience initializer
     
     - parameter aDecoder: This value is ignored
     
     - returns: a LoadingView object
     */
    convenience required public init?(coder aDecoder: NSCoder) {
        self.init()
    }
    
    
    /**
     Helper method to setup the view
     */
    func setupView() {
        self.backgroundColor = .judoLoadingBackgroundColor()

        self.translatesAutoresizingMaskIntoConstraints = false
        self.alpha = 0.0

        self.blockView.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.actionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.blockView.backgroundColor = .judoLoadingBlockViewColor()
        self.activityIndicatorView.activityIndicatorViewStyle = .Gray
        self.actionLabel.textColor = .judoDarkGrayColor()
        
        self.blockView.clipsToBounds = true
        self.blockView.layer.cornerRadius = 5.0
        
        self.addSubview(self.blockView)
        
        self.blockView.addSubview(self.activityIndicatorView)
        self.blockView.addSubview(self.actionLabel)
        
        self.blockView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-<=30-[activity]-25-[label]-<=30-|", options: .AlignAllCenterY, metrics: nil, views: ["activity":self.activityIndicatorView, "label":self.actionLabel]))
        self.blockView.addConstraint(NSLayoutConstraint(item: self.activityIndicatorView, attribute: .CenterY, relatedBy: .Equal, toItem: self.blockView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        self.blockView.addConstraint(NSLayoutConstraint(item: self.actionLabel, attribute: .CenterY, relatedBy: .Equal, toItem: self.blockView, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-<=30-[block(>=270)]-<=30-|", options: .AlignAllBaseline, metrics: nil, views: ["block":self.blockView]))
        
        self.addConstraint(NSLayoutConstraint(item: self.blockView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 110))
        self.addConstraint(NSLayoutConstraint(item: self.blockView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
    }
    
    
    /**
     Method to start the animation of the activityIndicator and make the view visible
     */
    func startAnimating() {
        self.activityIndicatorView.startAnimating()
        self.alpha = 1.0
    }
    
    
    /**
     Method to stop the animation of the activityIndicator and make the view invisible
     */
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.alpha = 0.0
    }
    
}
