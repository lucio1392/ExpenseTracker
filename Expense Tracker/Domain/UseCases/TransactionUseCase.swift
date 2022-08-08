//
//  TransactionUseCase.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RxSwift

protocol TransactionUseCase {
    func transactions(_ request: String?) -> Single<[Transaction]>
    func update(_ transaction: Transaction) -> Completable
    func add(_ transaction: Transaction) -> Completable
    func delete(_ transaction: Transaction) -> Completable
}
