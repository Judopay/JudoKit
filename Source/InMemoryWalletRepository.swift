//
//  InMemoryWalletRepository.swift
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

import Foundation

class InMemoryWalletRepository : WalletRepositoryProtocol {
    let wallet_repo = "wallet_repo"
    
    var repo = [WalletCard]()
    
    func save(walletCard: WalletCard) {
        self.repo.append(walletCard)
        let walletData = NSKeyedArchiver.archivedData(withRootObject: self.repo)
        UserDefaults.standard.set(walletData, forKey: wallet_repo)
    }
    
    func get() -> [WalletCard] {
        self.repo = self.getCardsArchived()
        return self.repo
    }
    
    func get(id: UUID) -> WalletCard? {
        return self.repo.filter({ return $0.id == id }).first
    }
    
    func remove(id: UUID) {
        self.removeCardFromArchive(id: id)
        
    }
    
    private func getCardsArchived()->[WalletCard]{
        var cards = self.repo
        if let walletData : Data = UserDefaults.standard.object(forKey: wallet_repo) as? Data {
            if let wallet_list = NSKeyedUnarchiver.unarchiveObject(with: walletData) {
                cards = wallet_list as! [WalletCard]
            }
        }
        return cards
    }
    
    private func removeCardFromArchive(id: UUID){
        var cards = self.repo
        var cardsFromArchive = self.getCardsArchived()
        var index = 0
        for card in cardsFromArchive {
            if card.id == id {
                cardsFromArchive.remove(at: index)
            }
            index += 1
        }
        cards = cardsFromArchive
        let walletData = NSKeyedArchiver.archivedData(withRootObject: cards)
        UserDefaults.standard.set(walletData, forKey: wallet_repo)
    }
}
