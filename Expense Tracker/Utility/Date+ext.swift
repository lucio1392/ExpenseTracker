//
//  Date+ext.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation

extension Date {
    func toString(_ format: String = "dd/MM") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
}
