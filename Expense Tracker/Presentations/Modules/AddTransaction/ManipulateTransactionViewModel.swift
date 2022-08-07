//
//  AddTransactionViewModel.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation
import RxSwift

protocol ManipulateTransactionViewModelType {
    var inputs: ManipulateTransactionViewModelInputType { get }
    var outputs: ManipulateTransactionViewModelOutputType { get }
}

protocol ManipulateTransactionViewModelInputType {
    var onCancelManipulateTransaction: PublishSubject<Void> { get }
}

protocol ManipulateTransactionViewModelOutputType {
    
}

final class ManipulateTransactionViewModel: ManipulateTransactionViewModelType, ManipulateTransactionViewModelInputType, ManipulateTransactionViewModelOutputType {
            
    var inputs: ManipulateTransactionViewModelInputType { return self }
    var outputs: ManipulateTransactionViewModelOutputType { return self }
    
//    inputs
    
    var onCancelManipulateTransaction: PublishSubject<Void> = PublishSubject<Void>()
    
    
    private let disposedBag = DisposeBag()
    private let navigator: HomeChartNavigatorType
    
    init(_ navigator: HomeChartNavigatorType,
         transaction: Transaction?) {
        
        self.navigator = navigator
        
        if let transaction = transaction {
//            Do Update Transaction
        } else {
//            Do Create Transaction
        }
        
        onCancelManipulateTransaction
            .do(onNext: navigator.dismiss)
            .subscribe()
            .disposed(by: disposedBag)
        
    }
    
}
