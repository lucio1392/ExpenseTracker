//
//  Application.swift
//  Expense Tracker
//
//  Created by Lucio on 07/08/2022.
//

import Foundation
import UIKit

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
}
