//
//  TransactionTableViewCell.swift
//  Expense Tracker
//
//  Created by Lucio on 07/08/2022.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {

    @IBOutlet fileprivate weak var transactionTitleLabel: UILabel!
    @IBOutlet fileprivate weak var transactionDateLabel: UILabel!
    @IBOutlet fileprivate weak var transactionAmountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        prepareUI()
    }
    
    func bind(_ viewModel: TransactionTableViewCellViewModel) {
        self.transactionTitleLabel.text = viewModel.title
        self.transactionDateLabel.text = viewModel.date
        self.transactionAmountLabel.text = viewModel.amount
    }
    
    fileprivate func prepareUI() {
        selectionStyle = .none
    }
    
}
