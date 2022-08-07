//
//  ViewController.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import UIKit
import Charts
import RealmSwift
import RxSwift
import RxCocoa

class HomeViewController: UIViewController {

    @IBOutlet fileprivate weak var totalLabel: UILabel!
    @IBOutlet fileprivate weak var barChartView: HomeChart!
    @IBOutlet fileprivate weak var transactionsTableView: UITableView!
    @IBOutlet fileprivate weak var addTransactionButton: UIButton!
    
    var viewModel: HomeViewModelType!
    
    private let disposedBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        bindViewModel()
    }
    
    fileprivate func configUI () {
        configTransactionTableView()
        configTransactionButton()
    }
    
    fileprivate func configTransactionTableView() {
        transactionsTableView.register(UINib(nibName: TransactionTableViewCell.reuseID, bundle: nil), forCellReuseIdentifier: TransactionTableViewCell.reuseID)
        transactionsTableView.estimatedRowHeight = 64
        transactionsTableView.rowHeight = UITableView.automaticDimension
        transactionsTableView.separatorInset = .zero
    }
    
    fileprivate func configTransactionButton() {
        addTransactionButton.setTitle("", for: .normal)
    }
    
    fileprivate func bindViewModel() {
        let outputs = viewModel.outputs
        let inputs = viewModel.inputs
        
//        Outputs
        let transactions = outputs
            .transactions
            .asDriver(onErrorJustReturn: [])
        
        transactions
            .drive(transactionsTableView.rx.items(cellIdentifier: TransactionTableViewCell.reuseID, cellType: TransactionTableViewCell.self)) { index, transaction, cell in
            let transactionCellViewModell = TransactionTableViewCellViewModel(transaction)
            cell.bind(transactionCellViewModell)
        }
            .disposed(by: disposedBag)
        
        
        transactions
            .flatMapLatest {
                return Driver.just("\($0.compactMap { $0.amount }.reduce(0, +))".toCurrencyFormat())
            }
            .drive(totalLabel.rx.text)
            .disposed(by: disposedBag)
            
        transactions
            .drive(onNext: { [weak self] transactions in
                guard let self = self else { return }
                self.updateBarChartView(transactions)
        })
            .disposed(by: disposedBag)
        
//        Inputs
        
        addTransactionButton
            .rx
            .tap
            .map { nil }
            .bind(to: inputs.onManipulateTransaction)
            .disposed(by: disposedBag)
        
        transactionsTableView
            .rx
            .modelSelected(Transaction.self)
            .bind(to: inputs.onManipulateTransaction)
            .disposed(by: disposedBag)
        
        
    }

    fileprivate func updateBarChartView(_ transactions: [Transaction]) {
        let chartDataEntries = transactions.enumerated().map { index, transaction in BarChartDataEntry(x: Double(index), y: transaction.amount) }
        let axisValue = IndexAxisValueFormatter(values: transactions.map { $0.day })
        self.barChartView.updateXAsixValue(axisValue)
        self.barChartView.updateChartData(chartDataEntries)
    }
}

