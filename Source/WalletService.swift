//
//  WalletService.swift
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

typealias OrderedWallet = [WalletCard]

struct WalletService {
    public let maxNumberOfCardsAllowed = 20
    private let repo: WalletRepositoryProtocol

    init(repo: WalletRepositoryProtocol) {
        self.repo = repo
    }
    
    func add(card: WalletCard) throws {
        guard self.walletIsNotFull() else {
            throw WalletError.walletCardLimitPassed
        }

        if self.walletIsEmpty() {
            //Make default as this will be the only card in the wallet.
            self.repo.save(walletCard: card.withDefaultCard())
        }
        else {
            if card.isPrimaryCard {
                self.resignCurrentDefault()
            }
            
            self.repo.save(walletCard: card)
        }
    }
    
    func update(card: WalletCard) throws {
        guard let currentCard = self.get(id: card.id) else {
            throw WalletError.unknownWalletCard
        }
        
        if self.isIllegallyResigningDefault(currentCard: currentCard, updatedCard: card) {
            throw WalletError.cannotResignDefaultCard
        }
        
        try! self.remove(card: card)
        try self.add(card: card)
    }
    
    func remove(card: WalletCard) throws {
        if self.getUnordered().count > 1 && card.isPrimaryCard {
            throw WalletError.cannotRemoveDefaultCard
        }
        
        self.repo.remove(id: card.id)
        
        if card.isPrimaryCard {
            self.resignCurrentDefault()
            
            if let newDefault = self.get().first {
                self.makeDefault(card: newDefault)
            }
        }
    }
    
    func get(id: UUID) -> WalletCard? {
        return self.repo.get(id: id)
    }
    
    func get() -> OrderedWallet {
        return self.getUnordered().sorted(by: { (lhs, rhs) -> Bool in
            if lhs.isPrimaryCard && !rhs.isPrimaryCard {
                return true
            }
            else if(!lhs.isPrimaryCard && rhs.isPrimaryCard) {
                return false
            }

            return lhs.dateCreated > rhs.dateCreated
        })
    }
  
    func getDefault() -> WalletCard? {
        return self.getUnordered().filter({ $0.isPrimaryCard }).first
    }
    
    private func makeDefault(card: WalletCard) {
        self.repo.remove(id: card.id)
        self.repo.save(walletCard: card.withDefaultCard())
    }
    
    private func resignCurrentDefault() {
        if let currentDefault = self.getDefault() {
            self.repo.remove(id: currentDefault.id)
            self.repo.save(walletCard: currentDefault.withNonDefaultCard())
        }
    }
    
    private func isIllegallyResigningDefault(currentCard: WalletCard, updatedCard: WalletCard) -> Bool {
        return !self.walletIsEmpty() && currentCard.isPrimaryCard && !updatedCard.isPrimaryCard
    }
    
    private func getUnordered() -> [WalletCard] {
        return self.repo.get()
    }
    
    private func walletIsEmpty() -> Bool {
        return self.get().count == 0
    }
    
    private func walletIsNotFull() -> Bool {
        return self.get().count < self.maxNumberOfCardsAllowed
    }
}
