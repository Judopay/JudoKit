//
//  AddCardCell.swift
//  JudoKit
//
//  Copyright (c) 2017 Alternative Payments Ltd
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

class AddCardCell: BaseCell {
    
    let addCardLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.height = 110.0
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.selectionStyle = .none
        
        addCardLabel.text = "Add a card"
        addCardLabel.font = UIFont.boldSystemFont(ofSize: 16)
        addCardLabel.textColor = UIColor(red: 30/255, green: 120/255, blue: 160/255, alpha: 1.0)
        addCardLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let centerY = contentView.frame.size.height
        contentView.addSubview(addCardLabel)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(y)-[label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["y":centerY+5], views: ["label":addCardLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[logo(46)]-18-[label]-28-|", options: .directionLeftToRight, metrics: nil, views: ["label": addCardLabel, "logo": self.logoContainerView]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
