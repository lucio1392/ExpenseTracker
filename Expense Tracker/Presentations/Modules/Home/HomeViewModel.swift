//
//  HomeViewModel.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

struct TransactionSectionData {
    var items: [Item]
}

extension TransactionSectionData: SectionModelType {
    typealias Item = Transaction
    
    init(original: TransactionSectionData, items: [Transaction]) {
        self = original
        self.items = items
    }
}

protocol HomeViewModelInputType {
    var onManipulateTransaction: PublishSubject<Transaction?> { get }
    var onDeleteTransaction: PublishSubject<Transaction> { get }
}

protocol HomeViewModelOutputType {
    var transactionSections: BehaviorSubject<[TransactionSectionData]> { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputType { get }
    var outputs: HomeViewModelOutputType { get }
}

final class HomeViewModel: HomeViewModelType, HomeViewModelInputType, HomeViewModelOutputType {
    
    var inputs: HomeViewModelInputType { return self }
    var outputs: HomeViewModelOutputType { return self }
    
    
    
    //    Outputs
    
    var transactionSections: BehaviorSubject<[TransactionSectionData]> = BehaviorSubject<[TransactionSectionData]>(value: [])
    
    //    Inputs
    var onManipulateTransaction: PublishSubject<Transaction?> = PublishSubject<Transaction?>()
    
    var onDeleteTransaction: PublishSubject<Transaction> = PublishSubject<Transaction>()
    
    private let disposedBag = DisposeBag()
    
    private let transactionUseCase: TransactionUseCase
    
    private let navigator: HomeChartNavigatorType
    
    init(_ transactionUseCase: TransactionUseCase,
         navigator: HomeChartNavigatorType) {
        self.navigator = navigator
        self.transactionUseCase = transactionUseCase
        
        self.transactionUseCase
            .transactions(nil)
            .asObservable()
            .flatMapLatest {
                return self.prepareTransactionSectionsData($0)
            }
            .bind(to: transactionSections)
            .disposed(by: disposedBag)
        
        self.onManipulateTransaction
            .do(onNext:  navigator.toManipulateTransaction(_:))
                .subscribe()
                .disposed(by: disposedBag)
                
        self.onDeleteTransaction
                .flatMapLatest { transaction -> Observable<Void> in
                    transactionUseCase.delete(transaction).andThen(.just(Void()))
                }.flatMapLatest {
                    transactionUseCase.transactions(nil)
                }
                .flatMapLatest {
                    self.prepareTransactionSectionsData($0)
                }
                .bind(to: transactionSections)
                .disposed(by: disposedBag)
        
        self.navigator
            .onUpdateTransaction
            .flatMapLatest {
                transactionUseCase.transactions(nil)
            }
            .flatMapLatest {
                self.prepareTransactionSectionsData($0)
            }
            .bind(to: transactionSections)
            .disposed(by: disposedBag)
    }
    
    fileprivate func prepareTransactionSectionsData(_ transactions: [Transaction]) -> Observable<[TransactionSectionData]> {
        return Observable.create { observer in
            observer.onNext([TransactionSectionData(items: transactions)])
            return Disposables.create {}
        }
    }
    
}
