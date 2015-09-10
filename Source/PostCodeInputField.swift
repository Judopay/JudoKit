//
//  PostCodeInputField.swift
//  JudoKit
//
//  Created by Hamon Riazy on 09/09/2015.
//  Copyright © 2015 Judo Payments. All rights reserved.
//

import UIKit

public class PostCodeInputField: JudoPayInputField {
    
    var billingCountry: BillingCountry = .UK
    
    // MARK: Custom methods
    
    override func placeholder() -> String? {
        return "000000"
    }
    
    override func title() -> String {
        return self.billingCountry.titleDescription()
    }

}
