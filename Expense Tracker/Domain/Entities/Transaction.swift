//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RealmSwift

class Transaction: Object {
    
    @Persisted var transactionId: String = UUID().uuidString
    @Persisted var title: String = ""
    @Persisted var date: Date = Date()
    @Persisted var amount: Double = 0
    
    convenience init(_ title: String, date: Date = Date(), amount: Double) {
        self.init()
        self.title = title
        self.date = date
        self.amount = amount
    }
    
    override class func primaryKey() -> String? {
        return "transactionId"
    }
    
}

extension Transaction {
    var day: String {
        return date.toString()
    }
}
