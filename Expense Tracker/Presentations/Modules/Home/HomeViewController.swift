//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import UIKit
import Charts
import ChartsRealm
import RealmSwift

class HomeViewController: UIViewController {

    var viewModel: HomeViewModelType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    fileprivate func bindViewModel() {
        
        let transactionRepository = LocalDatabaseUseCaseProvider().makeTransactionUseCase()
        viewModel = HomeViewModel(transactionRepository)
        
        viewModel.outputs.transactions.observe(onQueue: .main) { transactions in
//            Update list view and chart view 
            
            print("All Transactions: \(transactions)")
        }
    }


}

