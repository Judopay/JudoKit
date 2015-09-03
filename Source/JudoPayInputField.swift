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
        
        var visualFormat = "|-15-[title(50)]-[text]-15-|"
        var views = ["title":titleLabel, "text":textField]
        if self.containsLogo() {
            let logoView = self.logoView()!
            logoView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(logoView)
            
            visualFormat = "|-15-[title(50)]-[text]-[logo(38)]-15-|"
            views["logo"] = logoView
            
            self.addConstraint(NSLayoutConstraint(item: logoView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            logoView.addConstraint(NSLayoutConstraint(item: logoView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0))
        }
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: .DirectionLeftToRight, metrics: nil, views: views))
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
