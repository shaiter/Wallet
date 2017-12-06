//
//  Transaction.swift
//  Wallet
//
//  Created by Артём Шайтер on 11/30/17.
//  Copyright © 2017 Артём Шайтер. All rights reserved.
//

import UIKit
import os.log

class Transaction: NSObject, NSCoding {
    
    //MARK: Properties
    enum transactionTypes: Int {
        case income = 0, spending
    }
    var byn: Float!
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
    var date: String!
    var transactionType: Int!
    var transactionCategory: String!
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("transactions")
    
    //MARK: Types
    struct PropertyKey {
        static let transactionType = "transactionType"
        static let byn = "byn"
        static let transactionCategory = "transactionCategory"
        static let date = "date"
    }
    
    //MARK: Initialization
    init(byn: Float, date: String, transactionCategory: String, transactionType: Int) {
        self.byn = byn
        self.transactionCategory = transactionCategory
        self.transactionType = transactionType
        self.date = date
    }
    
    //MARK: NSCoding
    func  encode(with aCoder: NSCoder) {
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(byn, forKey: PropertyKey.byn)
        aCoder.encode(transactionCategory, forKey: PropertyKey.transactionCategory)
        aCoder.encode(transactionType, forKey: PropertyKey.transactionType)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as! String
        let byn = aDecoder.decodeObject(forKey: PropertyKey.byn) as! Float
        let transactionCategory = aDecoder.decodeObject(forKey: PropertyKey.transactionCategory) as! String
        let transactionType = aDecoder.decodeObject(forKey: PropertyKey.transactionType) as! Int
        self.init(byn: byn, date: date, transactionCategory: transactionCategory, transactionType: transactionType)
    }
    
}
