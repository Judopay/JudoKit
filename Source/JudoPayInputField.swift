//
//  JudoPayInputField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 03/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

public class JudoPayInputField: UIView, UITextFieldDelegate {

    let textField: UITextField = UITextField()
    
    let titleLabel: UILabel = UILabel()
    
    lazy var logoContainerView: UIView = UIView()
    
    // MARK: Initializers
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    func setupView() {
        self.textField.delegate = self
        self.textField.keyboardType = .NumberPad
        
        self.addSubview(self.textField)
        self.addSubview(self.titleLabel)
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[title]|", options: .AlignAllBaseline, metrics: nil, views: ["title":titleLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[text]|", options: .AlignAllBaseline, metrics: nil, views: ["text":textField]))
        
        self.titleLabel.textColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1.0)
        self.textField.textColor = UIColor(red: 75/255, green: 75/255, blue: 75/255, alpha: 1.0)
        
        self.titleLabel.font = UIFont.systemFontOfSize(14)
        self.textField.font = UIFont.boldSystemFontOfSize(14)
        
        self.textField.placeholder = self.placeholder()
        
        var visualFormat = "|-15-[title(45)][text]-15-|"
        var views = ["title":titleLabel, "text":textField]
        if self.containsLogo() {
            let logoView = self.logoView()!
            logoView.frame = CGRectMake(0, 0, 38, 25)
            self.addSubview(self.logoContainerView)
            self.logoContainerView.translatesAutoresizingMaskIntoConstraints = false
            self.logoContainerView.clipsToBounds = true
            self.logoContainerView.layer.cornerRadius = 2
            self.logoContainerView.addSubview(logoView)
            
            visualFormat = "|-15-[title(45)][text][logo(38)]-15-|"
            views["logo"] = self.logoContainerView
            
            self.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            self.logoContainerView.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0))
        }
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: .DirectionLeftToRight, metrics: nil, views: views))
    }
    
    // MARK: Helpers
    
    public func updateCardLogo() {
        self.logoContainerView.subviews.enumerate().forEach { $1.removeFromSuperview() }
        let logoView = self.logoView()!
        logoView.frame = CGRectMake(0, 0, 38, 25)
        self.logoContainerView.addSubview(logoView)
    }
    
    // MARK: Custom methods
    
    func placeholder() -> String? {
        return nil
    }
    
    func containsLogo() -> Bool {
        return false
    }
    
    func logoView() -> UIView? {
        return nil
    }
    
}
