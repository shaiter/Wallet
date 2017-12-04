//
//  Transaction.swift
//  Wallet
//
//  Created by Артём Шайтер on 11/30/17.
//  Copyright © 2017 Артём Шайтер. All rights reserved.
//

import UIKit

class Transaction {
    enum transactionTypes: Int {
        case income = 0, spending
    }
    var byn: Float
    var usd: Float {
        get {
            return (byn * 0.5)
        }
    }
    var eur: Float {
        get {
            return (byn * 0.42)
        }
    }
    var rub: Float {
        get {
            return(byn * 29.15)
        }
    }
    var transactionType: transactionTypes
    var transactionCategory: String
    let date: String
    
    
    init(byn: Float, transactionCategory: String, transactionType: Int) {
        self.byn = byn
        self.transactionCategory = transactionCategory
        self.transactionType = transactionTypes(rawValue: transactionType)!
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        self.date = formatter.string(from: Date())
    }
}
