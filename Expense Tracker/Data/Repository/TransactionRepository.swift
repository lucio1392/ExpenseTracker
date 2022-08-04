//
//  TransactionRepository.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RealmSwift

final class TransactionLocalDataRepository<Database>: TransactionUseCase where Database: CRUDType, Database.T == Transaction {

    private let repository: Database

    init(_ repository: Database) {
        self.repository = repository
    }
    
    func transactions(_ request: String?) -> [Transaction] {        
        repository.query(with: request)
    }
    
    func update(_ transaction: Transaction) {
        repository.update(entity: transaction)
    }
    
    func add(_ transaction: Transaction) {
        repository.save(entity: transaction)
    }
    
    func delete(_ transaction: Transaction) {
        repository.delete(entity: transaction)
    }
    
}


final class TransactionDataRepository<Request: NSPredicate>: TransactionUseCase {
    
    func transactions<T>(_ request: T) -> [Transaction] {
        return []
    }

    
    init() {
       
    }
    
    func update(_ transaction: Transaction) {
        
    }
    
    func add(_ transaction: Transaction) {
       
    }
    
    func delete(_ transaction: Transaction) {
        
    }
    
}
