//
//  Application.swift
//  Expense Tracker
//
//  Created by Lucio on 07/08/2022.
//

import Foundation
import UIKit
import RealmSwift

final class Application {
    static let shared = Application()
    
    private let transactionUseCase: TransactionUseCase
    
    private init() {
        transactionUseCase = LocalDatabaseUseCaseProvider().makeTransactionUseCase()
    }
    
    func configureAppInterfaceInitial(_ window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navigationController = UINavigationController()
        
        let homeChartController = HomeChartNavigator(storyboard, navigationController: navigationController, transactionUseCase: transactionUseCase)
        homeChartController.toHomeChart()
        window.rootViewController = navigationController
    }
    
//    Please note this func only run once when the we have no data. The purpose only for prepare data for testing
    func prepareDataForChart() {
        let realm = try! Realm()
        
        guard realm.objects(Transaction.self).count == 0 else {
            return
        }
        
        let transaction1 = Transaction("Food", amount: 20)
        let transaction2 = Transaction("Food-2", amount: 12)
        let transaction3 = Transaction("Food-3", amount: 29)
        let transaction4 = Transaction("Food-4", amount: 33)
        let transaction5 = Transaction("Food-5", amount: 56)
        
        let transactions = [transaction1, transaction2, transaction3, transaction4, transaction5]
                        
        try! realm.write {
            realm.add(transactions)
        }
    }
}
