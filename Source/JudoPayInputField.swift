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
        self.backgroundColor = .whiteColor()
        
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
        
        var visualFormat = "|-12-[title(50)][text]-12-|"
        var views = ["title":titleLabel, "text":textField]
        if self.containsLogo() {
            let logoView = self.logoView()!
            logoView.frame = CGRectMake(0, 0, 38, 25)
            self.addSubview(self.logoContainerView)
            self.logoContainerView.translatesAutoresizingMaskIntoConstraints = false
            self.logoContainerView.clipsToBounds = true
            self.logoContainerView.layer.cornerRadius = 2
            self.logoContainerView.addSubview(logoView)
            
            visualFormat = "|-12-[title(50)][text][logo(38)]-12-|"
            views["logo"] = self.logoContainerView
            
            self.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1.0, constant: 0.0))
            self.logoContainerView.addConstraint(NSLayoutConstraint(item: self.logoContainerView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1.0, constant: 25.0))
        }
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(visualFormat, options: .DirectionLeftToRight, metrics: nil, views: views))
    }
    
    // MARK: Helpers
    
    public func updateCardLogo() {
        let logoView = self.logoView()!
        logoView.frame = CGRectMake(0, 0, 38, 25)
        if let oldLogoView = self.logoContainerView.subviews.first as? CardLogoView {
            if oldLogoView.type != logoView.type {
                UIView.transitionFromView(self.logoContainerView.subviews.first!, toView: logoView, duration: 0.3, options: .TransitionFlipFromBottom, completion: nil)
            }
        }
    }
    
    // MARK: Custom methods
    
    func placeholder() -> String? {
        return nil
    }
    
    func containsLogo() -> Bool {
        return false
    }
    
    func logoView() -> CardLogoView? {
        return nil
    }
    
}
