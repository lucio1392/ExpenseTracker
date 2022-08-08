//
//  UseCaseProvider.swift
//  Expense Tracker
//
//  Created by Lucio on 04/08/2022.
//

import Foundation

protocol UseCaseProviderType {
    func makeTransactionUseCase() -> TransactionUseCase
}
