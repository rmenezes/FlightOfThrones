//
//  Extensions+Flight.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/28/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

extension Flight {
    func toFlightDepartureDurationAttributedString() -> NSAttributedString {
        let attr = NSMutableAttributedString(string: "\(outbound.departureTime) - \(outbound.arrivalTime)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attr.append(NSAttributedString(string: "\r\(outbound.departureDate) - \(outbound.arrivalDate)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: Apperance.Colors.middleGray]))
        
        return attr
    }
    
    func toFlightReturnDurationAttributedString() -> NSAttributedString {
        let attr = NSMutableAttributedString(string: "\(inbound.departureTime) - \(inbound.arrivalTime)", attributes: [
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15),
            NSAttributedString.Key.foregroundColor: UIColor.black])
        
        attr.append(NSAttributedString(string: "\r\(inbound.departureDate) - \(inbound.arrivalDate)", attributes: [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10),
            NSAttributedString.Key.foregroundColor: Apperance.Colors.middleGray]))
        
        return attr
    }
}

extension FlightByPrice {
    @inlinable mutating func convertPriceToCurrencyIfNeeded(currencies: [String: Double], currencyDestination: CurrencyExchange) {
        if currency == currencyDestination.rawValue {
            return
        }
        
        guard let factor = currencies[currency] else {
            return
        }
        
        minPrice = minPrice * factor
        currency = currencyDestination.rawValue
    }
}
