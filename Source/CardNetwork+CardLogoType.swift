//
//  CardNetwork+CardLogoType.swift
//  JudoKit
//
//  Created by ben.riazy on 07/01/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import Foundation
import Judo

public extension CardNetwork {
    public func cardLogoType() -> CardLogoType {
        switch self {
        case .Visa, .VisaDebit, .VisaElectron, .VisaPurchasing:
            return .Visa
        case .MasterCard, .MasterCardDebit:
            return .MasterCard
        case .AMEX:
            return .AMEX
        case .Maestro:
            return .Maestro
        default:
            return .Unknown
        }
    }
}
