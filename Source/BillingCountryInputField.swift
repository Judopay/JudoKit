//
//  BillingCountryInputField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 09/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

public enum BillingCountry: String {
    case UK, USA, Canada, Other
    
    public func titleDescription() -> String {
        switch self {
        case .USA:
            return "ZIP"
        case .Canada:
            return "Postal"
        default:
            return "Post"
        }
    }
}

public class BillingCountryInputField: JudoPayInputField {
    
    override func setupView() {
        super.setupView()
        
        self.textField.text = "UK"
    }
    
    override func title() -> String {
        return "Billing"
    }

}
