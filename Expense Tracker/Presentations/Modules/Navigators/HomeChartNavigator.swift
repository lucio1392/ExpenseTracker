//
//  HomeChartNavigator.swift
//  Expense Tracker
//
//  Created by Lucio on 07/08/2022.
//

import Foundation
import UIKit
import RxSwift

protocol HomeChartNavigatorType {
    var onUpdateTransaction: PublishSubject<Void> { get }
    
    
    func toHomeChart()
    func toManipulateTransaction(_ transaction: Transaction?)
    func dismiss()
}

final class HomeChartNavigator: HomeChartNavigatorType {

    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController
    private let transactionUseCase: TransactionUseCase
    
    var onUpdateTransaction: PublishSubject<Void> = PublishSubject<Void>()
    
    init(_ storyBoard: UIStoryboard,
         navigationController: UINavigationController,
         transactionUseCase: TransactionUseCase) {
        self.storyBoard = storyBoard
        self.navigationController = navigationController
        self.transactionUseCase = transactionUseCase
        self.configNavigationBar()
    }
    
    fileprivate func configNavigationBar() {
        self.navigationController.navigationBar.isHidden = true
    }
    
    func toHomeChart() {
        let homeChartController = storyBoard.instantiateViewController(ofType: HomeViewController.self)
        let homeChartViewModel = HomeViewModel(transactionUseCase,
                                               navigator: self)
        homeChartController.viewModel = homeChartViewModel
        
        navigationController.pushViewController(homeChartController, animated: false)
    }
    
    func toManipulateTransaction(_ transaction: Transaction?) {
        let manipulateTransactionController = storyBoard.instantiateViewController(ofType: ManipulateTransactionController.self)

        let manipulateTransactionViewModel = ManipulateTransactionViewModel(transactionUseCase,
                                                                            navigator: self,
                                                                            transaction: transaction)
        
        manipulateTransactionController.viewModel = manipulateTransactionViewModel
        
        navigationController.present(manipulateTransactionController, animated: true)
    }
    
    func dismiss() {
        navigationController.presentedViewController?.dismiss(animated: true)
    }
}
