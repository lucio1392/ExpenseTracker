//
//  TransactionUseCase.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation

protocol TransactionUseCase {
    func transactions(_ request: String?) -> [Transaction]
    func update(_ transaction: Transaction)
    func add(_ transaction: Transaction)
    func delete(_ transaction: Transaction)
}
