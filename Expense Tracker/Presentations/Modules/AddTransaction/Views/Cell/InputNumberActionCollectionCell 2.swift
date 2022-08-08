//
//  InputNumberActionCollectionCell.swift
//  Expense Tracker
//
//  Created by Lucio on 07/08/2022.
//

import UIKit

class InputNumberActionCollectionCell: UICollectionViewCell {
    @IBOutlet fileprivate weak var actionNumberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(_ viewModel: InputNumberActionCellViewModel) {
        actionNumberLabel.text = viewModel.actionNumber
    }

}
