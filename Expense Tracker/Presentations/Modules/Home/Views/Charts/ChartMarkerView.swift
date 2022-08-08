//
//  ChartMarkerView.swift
//  Expense Tracker
//
//  Created by Lucio on 08/08/2022.
//

import UIKit
import Charts
import SwiftUI

class ChartMarkerView: MarkerView {

    @IBOutlet fileprivate weak var inforView: UIView!
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var priceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initUI()
    }
    
    func update(_ transaction: Transaction) {
        self.inforView.layer.cornerRadius = 8.0
        self.titleLabel.text = transaction.title
        self.dateLabel.text = transaction.date.toString()
        self.priceLabel.text = "\(transaction.amount)".toCurrencyFormat()
    }

    private func initUI() {
        self.frame = CGRect(x: 0, y: 0, width: 125, height: 82)
        self.offset = CGPoint(x: -(self.frame.width/2), y: -self.frame.height)
    }
    
  

}
