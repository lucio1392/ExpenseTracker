//
//  TransactionChartRepository.swift
//  Expense Tracker
//
//  Created by Lucio on 06/08/2022.
//

import Foundation

final class TransactionChartRepository: TransactionChartUseCase {
    
    private let transactionUseCase: TransactionUseCase
    
    init(_ transactionUseCase: TransactionUseCase) {
        self.transactionUseCase = transactionUseCase
    }
    
    func weaklyTransaction() {
//        Get transactions in current week
    }
    
    func monthlyTransaction() {
        
    }
    
    func yearlyTransaction() {
        
    }

}
