//
//  AddTransactionViewModel.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RxSwift

fileprivate let removeInputAction = "<-"
fileprivate let dotInputAction = "."
fileprivate let zeroInputAction = "0"

typealias UpdatingTransactionAmount = (inputAction: String, currentAmount: String)
typealias OnUpdatingTransaction = (amount: String, title: String)

enum ValidateInputTransactionData: Error {
    case emptyTitle
    case unknown
    
    var description: String {
        switch self {
        case .emptyTitle:
            return "Please Input Transaction Title"
        case .unknown:
            return "Unknown Error"
        }
    }
}

protocol ManipulateTransactionViewModelType {
    var inputs: ManipulateTransactionViewModelInputType { get }
    var outputs: ManipulateTransactionViewModelOutputType { get }
}

protocol ManipulateTransactionViewModelInputType {
    var onCancelManipulateTransaction: PublishSubject<Void> { get }
    var onUpdateTransactionAmount: PublishSubject<UpdatingTransactionAmount> { get }
    var onUpdateTransaction: BehaviorSubject<OnUpdatingTransaction> { get }
}

protocol ManipulateTransactionViewModelOutputType {
    var actionNumber: BehaviorSubject<[InputNumberActionCellViewModel]> { get }
    var amountTransaction: BehaviorSubject<String> { get }
    var titleTransaction: BehaviorSubject<String> { get }
    var trackError: PublishSubject<String> { get }
}

final class ManipulateTransactionViewModel: ManipulateTransactionViewModelType, ManipulateTransactionViewModelInputType, ManipulateTransactionViewModelOutputType {
    
    var inputs: ManipulateTransactionViewModelInputType { return self }
    var outputs: ManipulateTransactionViewModelOutputType { return self }
    //    outputs
    
    var amountTransaction: BehaviorSubject<String>
    
    var titleTransaction: BehaviorSubject<String>
    
    var trackError: PublishSubject<String> = PublishSubject<String>()
    
    //    inputs
    
    var onCancelManipulateTransaction: PublishSubject<Void> = PublishSubject<Void>()
    
    var onUpdateTransactionAmount: PublishSubject<UpdatingTransactionAmount> = PublishSubject<UpdatingTransactionAmount>()
    
    var onUpdateTransaction: BehaviorSubject<OnUpdatingTransaction>
    
    var actionNumber: BehaviorSubject<[InputNumberActionCellViewModel]> = BehaviorSubject<[InputNumberActionCellViewModel]>(value: [
        InputNumberActionCellViewModel("7"),
        InputNumberActionCellViewModel("8"),
        InputNumberActionCellViewModel("9"),
        InputNumberActionCellViewModel("4"),
        InputNumberActionCellViewModel("5"),
        InputNumberActionCellViewModel("6"),
        InputNumberActionCellViewModel("1"),
        InputNumberActionCellViewModel("2"),
        InputNumberActionCellViewModel("3"),
        InputNumberActionCellViewModel("."),
        InputNumberActionCellViewModel("0"),
        InputNumberActionCellViewModel("<-")
    ])
    
    private let disposedBag = DisposeBag()
    private let navigator: HomeChartNavigatorType
    private let transactionUseCase: TransactionUseCase
    
    init(_ transactionUseCase: TransactionUseCase,
         navigator: HomeChartNavigatorType,
         transaction: Transaction?) {
        
        self.navigator = navigator
        self.transactionUseCase = transactionUseCase
        
        self.amountTransaction = BehaviorSubject<String>(value: "\(transaction?.amount ?? 0)")
        self.titleTransaction = BehaviorSubject<String>(value: transaction?.title ?? "")
        
        self.onUpdateTransaction = BehaviorSubject<OnUpdatingTransaction>(value: ("\(transaction?.amount ?? 0)", transaction?.title ?? ""))
        
        let onUpdate = onUpdateTransaction
            .flatMapLatest { [weak self] info -> Observable<Event<()>> in
                guard let self = self else {
                    return .empty()
                }
                return self.checkingUpdatingInformation(info.title).materialize()
            }


        onUpdate
            .map { $0.error as? ValidateInputTransactionData }
            .filter { $0 != nil }
            .flatMapLatest { error -> Observable<String> in
                let error = error?.description ?? ValidateInputTransactionData.unknown.description
                return .just(error)
            }
            .bind(to: trackError)
            .disposed(by: disposedBag)

        let updatingTransaction = onUpdate
            .filter { $0.element != nil }
            .withLatestFrom(onUpdateTransaction)
            .share()

        if let transaction = transaction {
            updatingTransaction
                .map { updatingInfor in
                    return Transaction(transaction.transactionId,
                                title: updatingInfor.title,
                                date: transaction.date,
                                amount: Double(updatingInfor.amount) ?? 0)
                }
                .flatMapLatest { transaction -> Observable<Void> in
                    transactionUseCase.update(transaction).andThen(.just(Void()))
                }
                .do(onNext: navigator.dismiss)
                .bind(to: navigator.onUpdateTransaction)
                .disposed(by: disposedBag)

        } else {
            updatingTransaction
                .map { updatingInfor in
                    Transaction(updatingInfor.title, amount: Double(updatingInfor.amount) ?? 0)
                }
                .flatMapLatest { transaction -> Observable<Void> in
                    transactionUseCase.add(transaction).andThen(.just(()))
                }
                .do(onNext: navigator.dismiss)
                .bind(to: navigator.onUpdateTransaction)
                .disposed(by: disposedBag)
        }
        
        onUpdateTransactionAmount
            .flatMapLatest { [weak self] amount -> Observable<String> in
                guard let self = self else { return .empty() }
                return self.updateAmountTransaction(amount)
            }
            .bind(to: amountTransaction)
            .disposed(by: disposedBag)
        
        onCancelManipulateTransaction
            .do(onNext: navigator.dismiss)
            .subscribe()
            .disposed(by: disposedBag)
        
    }
    
    private func checkingUpdatingInformation(_ title: String) -> Observable<()> {
        return Observable.create { observer in
            
            guard !title.isEmpty else {
                observer.onError(ValidateInputTransactionData.emptyTitle)
                return Disposables.create {}
            }
            
            observer.onNext(())
            return Disposables.create { }
        }
    }
    
    private func updateAmountTransaction(_ updatingTransaction: UpdatingTransactionAmount) -> Observable<String> {
        
        return Observable.create { observer in
            var currentAmount = updatingTransaction.currentAmount
            let inputAction = updatingTransaction.inputAction
            
            if inputAction == removeInputAction {
                currentAmount.removeLast()
                observer.onNext(currentAmount.isEmpty ? "0" : currentAmount)
                return Disposables.create {}
            }
            
            if inputAction == dotInputAction && currentAmount.contains(dotInputAction) {
                observer.onNext(currentAmount)
                return Disposables.create {}
            }
            
            if currentAmount == zeroInputAction && inputAction != dotInputAction {
                observer.onNext(inputAction)
                return Disposables.create {}
            }
            
            observer.onNext(currentAmount + inputAction)
            return Disposables.create {}
        }
    }
    
    deinit {
        print("Deinit viewmodel")
    }
    
}
