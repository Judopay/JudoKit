//
//  UINavigationBar+Judo.swift
//  JudoKit
//
//  Created by Nazar Yavornytskyy on 4/27/17.
//  Copyright © 2017 Judo Payments. All rights reserved.
//

import Foundation

extension UINavigationBar {
    
    func setBottomBorderColor(color: UIColor, height: CGFloat) {
        let bottomBorderRect = CGRect(x: 0, y: frame.height, width: frame.width, height: height)
        let bottomBorderView = UIView(frame: bottomBorderRect)
        bottomBorderView.backgroundColor = color
        addSubview(bottomBorderView)
    }
}
