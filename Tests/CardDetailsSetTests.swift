//
//  CardDetailsSetTests.swift
//  JudoKit
//
//  Created by Ashley Barrett on 12/05/2016.
//  Copyright © 2016 Judo Payments. All rights reserved.
//

import XCTest

@testable import JudoKit

class CardDetailsSetTests : JudoTestCase{
    func test_card_details_must_be_present(){
        let cardDetails = CardDetails(cardNumber: "4976000000003436", expiryMonth: 12, expiryYear: 20)
        
        let jpvc = JudoPayViewController(judoId: myJudoId, amount: oneGBPAmount, reference: validReference, transactionType: .Payment, completion: {_ in}, currentSession: judo, cardDetails: cardDetails, paymentToken: nil)
        
        let cardInputField = jpvc.myView.cardInputField
        let expiryDateInputField = jpvc.myView.expiryDateInputField
        
        XCTAssertEqual(false, cardInputField.isTokenPayment)
        XCTAssertEqual("4976 0000 0000 3436", cardInputField.textField.text)
        XCTAssertEqual("12/20", expiryDateInputField.textField.text)
    }
    
    func test_card_details_must_be_masked(){
        let cardDetails = CardDetails(cardNumber: "4976000000003436", expiryMonth: 12, expiryYear: 20)
        let token = PaymentToken(consumerToken: "MY CONSUMER TOKEN", cardToken: "MY CARD TOKEN")
        
        let jpvc = JudoPayViewController(judoId: myJudoId, amount: oneGBPAmount, reference: validReference, transactionType: .Payment, completion: {_ in}, currentSession: judo, cardDetails: cardDetails, paymentToken: token)
        
        let cardInputField = jpvc.myView.cardInputField
        let expiryDateInputField = jpvc.myView.expiryDateInputField
        
        XCTAssertEqual(true, cardInputField.isTokenPayment)
        XCTAssertEqual("**** **** **** 3436", cardInputField.textField.text)
        XCTAssertEqual("12/20", expiryDateInputField.textField.text)
    }
    
    func test_card_details_must_not_be_present(){
        let token = PaymentToken(consumerToken: "MY CONSUMER TOKEN", cardToken: "MY CARD TOKEN")
        
        let jpvc = JudoPayViewController(judoId: myJudoId, amount: oneGBPAmount, reference: validReference, transactionType: .Payment, completion: {_ in}, currentSession: judo, cardDetails: nil, paymentToken: token)
        
        let cardInputField = jpvc.myView.cardInputField
        let expiryDateInputField = jpvc.myView.expiryDateInputField
        
        XCTAssertEqual(true, cardInputField.isTokenPayment)
        XCTAssertEqual(nil, cardInputField.textField.text)
        XCTAssertEqual(nil, expiryDateInputField.textField.text)
    }
}