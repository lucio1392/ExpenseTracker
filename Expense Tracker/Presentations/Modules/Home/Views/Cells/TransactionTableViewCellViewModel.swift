//
//  TransactionTableViewCellViewModel.swift
//  Expense Tracker
//
//  Created by Lucio on 07/08/2022.
//

import Foundation

final class TransactionTableViewCellViewModel {
    let title: String?
    let date: String?
    let amount: String?
    let transaction: Transaction
    
    init(_ transaction: Transaction) {
        self.title = transaction.title
        self.date = transaction.date.toString("HH:mm dd-MM-yyyy")
        self.amount = "\(transaction.amount)".toCurrencyFormat()
        self.transaction = transaction
    }
}
