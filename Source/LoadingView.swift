//
//  LoadingView.swift
//  JudoKit
//
//  Created by Hamon Riazy on 07/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

public class LoadingView: UIView {
    
    private let blockView = UIView()
    private let activityIndicatorView = UIActivityIndicatorView()
    let actionLabel = UILabel()
    
    public init() {
        super.init(frame: CGRectZero)
        self.setupView()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.backgroundColor = .judoLoadingBackgroundColor()
        
        self.blockView.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.actionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.blockView.backgroundColor = UIColor.whiteColor()
        self.activityIndicatorView.activityIndicatorViewStyle = .Gray
        self.actionLabel.textColor = .judoDarkGrayColor()
        
        self.actionLabel.text = "Processing Payment"
        
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
    
    func startAnimating() {
        self.activityIndicatorView.startAnimating()
        self.alpha = 1.0
    }
    
    func stopAnimating() {
        self.activityIndicatorView.stopAnimating()
        self.alpha = 0.0
    }
    
}
