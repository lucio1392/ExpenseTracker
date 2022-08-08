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
import RxDataSources

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
        transactionsTableView.setEditing(false, animated: true)
    }
    
    fileprivate func configTransactionButton() {
        addTransactionButton.setTitle("", for: .normal)
    }
    
    fileprivate func bindViewModel() {
        let outputs = viewModel.outputs
        let inputs = viewModel.inputs
        
        let dataSource = RxTableViewSectionedReloadDataSource<TransactionSectionData>(configureCell: { datasource, tableview, indexPath, transaction in
            let transactionCell = tableview.dequeueReusableCell(withIdentifier: TransactionTableViewCell.reuseID, for: indexPath) as? TransactionTableViewCell
            
            let viewModel = TransactionTableViewCellViewModel(transaction)
            
            transactionCell?.bind(viewModel)
            
            return transactionCell ?? UITableViewCell()
        },
            canEditRowAtIndexPath: {
            _, _ in
            return true
        })
 
//        Outputs
        
        let transactions = outputs
            .transactionSections
            .asDriver(onErrorJustReturn: [])
            .compactMap { $0.first }
        
        outputs
            .transactionSections
            .bind(to: transactionsTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposedBag)
        
        transactions
            .flatMapLatest {
                return Driver.just("\($0.items.compactMap { $0.amount }.reduce(0, +))".toCurrencyFormat())
            }
            .drive(totalLabel.rx.text)
            .disposed(by: disposedBag)
            
        transactions
            .drive(onNext: { [weak self] transactionSection in
                guard let self = self else { return }
                self.updateBarChartView(transactionSection.items)
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
            .modelDeleted(Transaction.self)
            .bind(to: inputs.onDeleteTransaction)
            .disposed(by: disposedBag)
        
        transactionsTableView
            .rx
            .modelSelected(Transaction.self)
            .bind(to: inputs.onManipulateTransaction)
            .disposed(by: disposedBag)        
  
    }

    fileprivate func updateBarChartView(_ transactions: [Transaction]) {
        self.barChartView.updateChartData(transactions)
    }
}

