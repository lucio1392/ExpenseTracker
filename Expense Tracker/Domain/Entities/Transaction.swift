//
//  Transaction.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RealmSwift

class Transaction: Object {
    
    @objc dynamic var transactionId: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var date: Date = Date()
    @objc dynamic var amount: Double = 0
    
    convenience init(_ title: String, date: Date, amount: Double) {
        self.init()
        self.title = title
        self.date = date
        self.amount = amount
    }
    
    override class func primaryKey() -> String? {
        return "transactionId"
    }
    
    
}
