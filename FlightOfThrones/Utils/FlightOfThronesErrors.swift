//
//  FlightOfThronesErrors.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/28/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

enum FlightOfThronesErrors: Error {
    case cannotFetchOnlineFlights(String)
    case cannotFetchCurrency(String)
    case cannotSaveFlight(String)
    case cannotSaveDestination(String)
    case cannotFeatchLocalFlights(String)
    case invalidResponseFormat(String)
    case notConnectedWithTheInternet(String)
}

extension FlightOfThronesErrors {
    func getMessage() -> String {
        switch self {
        case .cannotFetchOnlineFlights(let message):
            return message
        case .cannotFetchCurrency(let message):
            return message
        case .cannotSaveFlight(let message):
            return message
        case .cannotSaveDestination(let message):
            return message
        case .cannotFeatchLocalFlights(let message):
            return message
        case .invalidResponseFormat(let message):
            return message
        case .notConnectedWithTheInternet(let message):
            return message
        }
    }
}
