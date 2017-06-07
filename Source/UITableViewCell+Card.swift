//
//  UITableViewCell+Card.swift
//  JudoKit
//
//  Created by Nazar Yavornytskyy on 6/5/17.
//  Copyright © 2017 Judo Payments. All rights reserved.
//

import Foundation

extension UITableViewCell {
    
    func enable(on: Bool) {
//        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            view.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}
