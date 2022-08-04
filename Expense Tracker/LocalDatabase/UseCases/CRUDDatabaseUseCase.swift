//
//  CRUDDatabaseUseCase.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation

final class LocalDatabaseUseCaseProvider: UseCaseProviderType {
    
    private let realmDB = RealmDB()
    private let transactionRepository: RealmDBRepository<Transaction>
    
    init() {
        transactionRepository = RealmDBRepository(realmDB.realm)
    }
        
    func makeTransactionUseCase() -> TransactionUseCase {
        return TransactionLocalDataRepository<RealmDBRepository>(transactionRepository)
    }
    
    
}
