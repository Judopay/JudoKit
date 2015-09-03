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
        
        var visualFormat = "|-[title(50)]-[text]-|"
        var views = ["title":titleLabel, "text":textField]
        if self.containsLogo() {
            let logoView = self.logoView()!
            logoView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(logoView)
            visualFormat = "|-[title(50)]-[text]-[logo(38)]-|"
            views["logo"] = logoView

            self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[logo]|", options: .AlignAllBaseline, metrics: nil, views: ["logo":logoView]))
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
