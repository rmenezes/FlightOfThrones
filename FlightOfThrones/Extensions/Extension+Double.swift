//
//  Extension+Double.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/28/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

fileprivate let numberFormat: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.maximumFractionDigits = 2
    formatter.minimumFractionDigits = 2
    formatter.decimalSeparator = "."
    formatter.usesGroupingSeparator = true
    formatter.numberStyle = .currency
    formatter.currencySymbol = ""
    return formatter
}()

extension Double {
    func toCurrencyAttributesString(currency: String, withSize size: CGFloat) -> NSAttributedString {
        // Price Label
        let price = numberFormat.string(from: NSNumber(value: self))?.split(separator: ".")
        // Symbol
        let attr = NSMutableAttributedString(string: currency, attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        // Decimal
        attr.append(NSAttributedString(string: String(price![0]), attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size * 2),
            NSAttributedString.Key.foregroundColor: UIColor.black]))
        // Decinal Places
        attr.append(NSAttributedString(string:  ".\(price![1])", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size),
            NSAttributedString.Key.foregroundColor: UIColor.black]))
        
        return attr
    }
}
