//
//  HomeViewModel.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInputType {
    var onManipulateTransaction: PublishSubject<Transaction?> { get }
}

protocol HomeViewModelOutputType {
    var transactions: BehaviorSubject<[Transaction]> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputType { get }
    var outputs: HomeViewModelOutputType { get }
}

final class HomeViewModel: HomeViewModelType, HomeViewModelInputType, HomeViewModelOutputType {
    
    var inputs: HomeViewModelInputType { return self }
    var outputs: HomeViewModelOutputType { return self }
    
    
    
//    Outputs
    
    var transactions: BehaviorSubject<[Transaction]> = BehaviorSubject<[Transaction]>(value: [])
    
//    Inputs
    var onManipulateTransaction: PublishSubject<Transaction?> = PublishSubject<Transaction?>()
    
    private let disposedBag = DisposeBag()

    private let transactionUseCase: TransactionUseCase
    
    private let navigator: HomeChartNavigatorType
    
    init(_ transactionUseCase: TransactionUseCase,
         navigator: HomeChartNavigatorType) {
        self.navigator = navigator
        self.transactionUseCase = transactionUseCase
        
        self.transactionUseCase
            .transactions(nil)
            .subscribe(onSuccess: { transactions in
            self.transactions.onNext(transactions)
        })
            .disposed(by: disposedBag)
        
        self.onManipulateTransaction
            .do(onNext:  navigator.toManipulateTransaction(_:))
            .subscribe()
            .disposed(by: disposedBag)
    
    }

}
