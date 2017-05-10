//
//  BaseCell.swift
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

class BaseCell: UITableViewCell {
    
    let cellView = UIView()
    internal lazy var logoContainerView: UIView = UIView()
    let arrowLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.frame.size.height = 110.0
        let centerY = contentView.frame.size.height
        
        cellView.translatesAutoresizingMaskIntoConstraints = false
        cellView.layer.borderColor = UIColor.gray.cgColor
        cellView.layer.borderWidth = 1.0
        cellView.layer.cornerRadius = 8.0
        contentView.addSubview(cellView)
        
        let logoView = CardLogoView.init(type: .addCard)
        logoView.frame = CGRect(x: 0, y: 0, width: 46, height: 30)
        self.addSubview(self.logoContainerView)
        self.logoContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.logoContainerView.clipsToBounds = true
        self.logoContainerView.layer.cornerRadius = 2
        self.logoContainerView.addSubview(logoView)
        
        contentView.addSubview(logoContainerView)
        
        arrowLabel.text = ">"
        arrowLabel.textColor = UIColor.darkGray
        arrowLabel.font = UIFont.boldSystemFont(ofSize: 22)
        contentView.addSubview(arrowLabel)
        arrowLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(y)-[logo(30)]", options: .alignAllLastBaseline, metrics: ["y":centerY], views: ["logo":self.logoContainerView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-28-[content]-20-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["content":cellView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-24-[content]-24-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["content": cellView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(y)-[arrow]", options: NSLayoutFormatOptions(rawValue: 0), metrics: ["y":centerY], views: ["arrow":arrowLabel]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[arrow]-42-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["arrow": self.arrowLabel]))

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
