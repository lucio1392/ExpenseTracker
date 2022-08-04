//
//  HomeViewModel.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation


protocol HomeViewModelInputType {
    var onDeleteTransaction: PublishBinding<Transaction> { get }
    var onUpdateTransaction: PublishBinding<Transaction> { get }
    var onCreateTransaction: PublishBinding<Void> { get }
}

protocol HomeViewModelOutputType {
    var transactions: ReplayBinding<[Transaction]> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputType { get }
    var outputs: HomeViewModelOutputType { get }
}

final class HomeViewModel: HomeViewModelType, HomeViewModelInputType, HomeViewModelOutputType {
    
    var inputs: HomeViewModelInputType { return self }
    var outputs: HomeViewModelOutputType { return self }
    
    //Outputs
    
    var transactions: ReplayBinding<[Transaction]> = ReplayBinding<[Transaction]>(value: [])
    
//    Inputs
    
    var onDeleteTransaction: PublishBinding<Transaction> = PublishBinding<Transaction>()
    var onUpdateTransaction: PublishBinding<Transaction> = PublishBinding<Transaction>()
    var onCreateTransaction: PublishBinding<Void> = PublishBinding<Void>()
    
    private let transactionUseCase: TransactionUseCase
    
    init(_ transactionUseCase: TransactionUseCase) {
        self.transactionUseCase = transactionUseCase
        
        self.onSyncTransactionList()
    
        onDeleteTransaction
            .observe(onQueue: .global(qos: .background)) { transation in
            self.transactionUseCase.delete(transation)
            self.onSyncTransactionList()
        }
        
        onCreateTransaction.observe(onQueue: .main) {
//            Navigate to Add Transaction Controller
        }
        
        onUpdateTransaction.observe(onQueue: .main) { transaction in
//            Navigate to Add Transaction Controller with updating transaction
        }
    }
    
    private func onSyncTransactionList() {
        transactions.onEvent(self.transactionUseCase.transactions(nil))
    }
}
