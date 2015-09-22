//
//  PayButton.swift
//  JudoKit
//
//  Created by Hamon Riazy on 22/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

public class PayButton: UIButton {
    
    // MARK: initialization
    
    public init() {
        super.init(frame: CGRectZero)
        self.setupView()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupView()
    }
    
    // MARK: View Setup
    
    public func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .judoButtonColor()
        self.setTitle("Pay", forState: .Normal)
        self.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        self.titleLabel?.font = UIFont.boldSystemFontOfSize(22)
        self.enabled = false
        self.alpha = 0.25
        self.titleLabel?.alpha = 0.5
    }
    
    // MARK: configuration
    
    public func paymentEnabled(enabled: Bool) {
        self.paymentButton.enabled = enabled
        self.paymentButton.alpha = enabled ? 1.0 : 0.25
        self.paymentButton.titleLabel?.alpha = enabled ? 1.0 : 0.5
    }

}
