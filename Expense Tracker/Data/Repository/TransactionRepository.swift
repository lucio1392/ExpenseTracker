//
//  TransactionRepository.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RealmSwift
import RxSwift

final class TransactionLocalDataRepository<Database>: TransactionUseCase where Database: CRUDType, Database.T == Transaction {

    private let repository: Database

    init(_ repository: Database) {
        self.repository = repository
    }
    
    func transactions(_ request: String?) -> Single<[Transaction]> {
        return repository.query(with: request)
    }
    
    func update(_ transaction: Transaction) -> Completable {
        return repository.update(entity: transaction)
    }
    
    func add(_ transaction: Transaction) -> Completable {
        return repository.save(entity: transaction)
    }
    
    func delete(_ transaction: Transaction) -> Completable {
        return repository.delete(entity: transaction)
    }
    
}

