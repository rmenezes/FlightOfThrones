//
//  Extensions+String.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

extension String {
    func currencyToSymbol() -> String {
        switch self {
        case "EUR":
            return "€"
        case "GBP":
            return "£"
        case "USD":
            return "$"
        case "JPN":
            return "¥"
        default:
            return ""
        }
    }
}
