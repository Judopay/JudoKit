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
        self.textField.frame = self.frame
        self.textField.delegate = self
        self.addSubview(self.textField)
        self.addSubview(self.titleLabel)
        
        self.textField.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-[title]", options: .DirectionLeftToRight, metrics: nil, views: ["title":titleLabel]))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-50-[text]", options: .DirectionLeftToRight, metrics: nil, views: ["text":textField]))
        
    }
    
}
