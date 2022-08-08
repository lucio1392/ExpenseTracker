//
//  String+ext.swift
//  Expense Tracker
//
//  Created by Lucio on 03/08/2022.
//

import Foundation

extension String{
    func toCurrencyFormat(with locale: Locale = Locale.current) -> String {
        if let intValue = Double(self){
           let numberFormatter = NumberFormatter()
           numberFormatter.locale = locale
           numberFormatter.numberStyle = NumberFormatter.Style.currency
           return numberFormatter.string(from: NSNumber(value: intValue)) ?? ""
      }
    return ""
  }
    
    func toDouble() -> Double {
        return Double(self) ?? 0.0
    }
}
