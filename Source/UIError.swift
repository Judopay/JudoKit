//
//  UIError.swift
//  JudoKit
//
//  Created by Ashley Barrett on 18/04/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import Foundation

public class UIError
{
    public let title: String?
    public let message: String?
    public let hint: String?
    
    public init(tile: String?, message: String?, hint: String?)
    {
        self.title = tile
        self.message = message
        self.hint = hint
    }
}