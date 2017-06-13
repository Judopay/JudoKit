//
//  CardCell.swift
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

class CardCell: BaseCell {
    
    var walletCard: WalletCard? {
    
        didSet{
            updateTitles()
        }
    }
    var paymentToken: PaymentToken?
    
    let cardNameLabel = UILabel()
    let cardSubLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.selectionStyle = .none
        
        contentView.addSubview(cardNameLabel)
        contentView.addSubview(cardSubLabel)
        
        cardNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        cardNameLabel.textColor = UIColor.init(red: 75/255, green: 75/255, blue: 75/255, alpha: 1.0)
        cardNameLabel.translatesAutoresizingMaskIntoConstraints = false
        cardSubLabel.font = UIFont.systemFont(ofSize: 12)
        cardSubLabel.textColor = UIColor.init(red: 130/255, green: 130/255, blue: 130/255, alpha: 1.0)
        cardSubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-22-[label]-5-[sub_label]", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["label":cardNameLabel, "sub_label":cardSubLabel]))
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[logo(46)]-18-[label]-28-|", options: .directionLeftToRight, metrics: nil, views: ["label": cardNameLabel, "logo": self.logoContainerView]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[logo(46)]-18-[sub_label]-28-|", options: .directionLeftToRight, metrics: nil, views: ["sub_label": cardSubLabel, "logo": self.logoContainerView]))
    }
    
    func updateTitles(){
        cardNameLabel.text = walletCard?.assignedName == "" ? walletCard?.cardDetails?.cardNetwork?.stringValue() : walletCard?.assignedName
        let text = "****"+(walletCard?.cardNumberLastFour)!+" • Expiry "+(walletCard?.expiryDate)!
        if (walletCard?.isPrimaryCard)! {
            let attrString = NSMutableAttributedString()
            attrString.normal(text).bold(" • Primary")
            cardSubLabel.attributedText = attrString
            cellView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.07)
        }
        if (walletCard?.hasCardExpired())! {
            var attrString = NSMutableAttributedString()
            attrString = NSMutableAttributedString(string: text)
            attrString.setAttributes([NSForegroundColorAttributeName : UIColor.red], range: NSRange(location:11,length:12))
            cardSubLabel.attributedText = attrString
            self.enable(on: false)
        } else {
            if !(walletCard?.isPrimaryCard)! {
                cardSubLabel.text = text
            }
        }
        logoView = CardLogoView.init(type: (walletCard?.cardType)!)
        logoView.frame = CGRect(x: 0, y: 0, width: 46, height: 30)
        logoContainerView.addSubview(logoView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
