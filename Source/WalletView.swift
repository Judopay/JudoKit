//
//  WalletView.swift
//  JudoKit
//
//  Copyright (c) 2016 Alternative Payments Ltd
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

/// JudoPayView - the main view in the transaction journey
open class WalletView: UIView {
    
    /// The content view of the JudoPayView
    open let contentView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isDirectionalLockEnabled = true
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    let theme: Theme
    
    var delegate: WalletCardOperationProtocol!
    var walletService: WalletService!
    
    /**
     Designated initializer
     
     - parameter type:        The transactionType of this transaction
     - parameter cardDetails: Card details information if they have been passed
     
     - returns: a JudoPayView object
     */
    public init(currentTheme: Theme) {
        self.theme = currentTheme
        super.init(frame: UIScreen.main.bounds)
        
        self.setupView()
    }
    
    
    /**
     Required initializer for the JudoPayView that will fail
     
     - parameter aDecoder: A Decoder
     
     - returns: a fatal error will be thrown as this class should not be retrieved by decoding
     */
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: View LifeCycle
    func setupView(){
        // View
        self.addSubview(contentView)
        let navHeight:CGFloat = 60.0
        self.contentView.frame = CGRect.init(x: self.bounds.origin.x, y: self.bounds.origin.y + navHeight, width: self.bounds.size.width, height: self.bounds.size.height-navHeight)
        self.contentView.contentSize = self.bounds.size
        //Reload card table
        self.contentView.dataSource = self
        self.contentView.delegate = self
        self.contentView.separatorStyle = .none
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }

}

extension WalletView : UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.walletService.get().count {
            delegate.onAddWalletCard()
        } else {
            delegate.onSelectWalletCard(card: self.walletService.get()[indexPath.row])
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.walletService.get().count+1//+1 reserved an item for Add Card cell
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == self.walletService.get().count {
            return WalletCellFactory().createCard(cardType: 0)
        }
        let item = self.walletService.get()[indexPath.row]
        return WalletCellFactory().createCardCell(walletCard: item)
    }
    
}

