//
//  Extension+NSManagedFlight.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

extension ManagedFlight {
    func toFlight() -> Flight {
        let outbound = DragonFlight(airline: outAirline!, airlineImage: outArlineImage!, arrivalDate: outArrivalDate!, arrivalTime: outArrivalTime!, departureDate: outDepartureDate!, departureTime: outDepartureTime!, destination: outDestination!, origin: outOrigin!)
        let inbound = DragonFlight(airline: inArline!, airlineImage: inArlineImage!, arrivalDate: inArrivalDate!, arrivalTime: inArrivalTime!, departureDate: inDepartureDate!, departureTime: inDepartureTime!, destination: inDestination!, origin: inOrigin!)
        
        return Flight(price: price, currency: currency!, inbound: inbound, outbound: outbound)
    }
    
    func fromFlight(flight: Flight) {
        outAirline = flight.outbound.airline
        outArlineImage = flight.outbound.airlineImage
        outArrivalDate = flight.outbound.arrivalDate
        outArrivalTime = flight.outbound.arrivalTime
        outDepartureDate = flight.outbound.departureDate
        outDepartureTime = flight.outbound.departureTime
        outDestination = flight.outbound.destination
        outOrigin = flight.outbound.origin
        
        inArline = flight.inbound.airline
        inArlineImage = flight.inbound.airlineImage
        inArrivalDate = flight.inbound.arrivalDate
        inArrivalTime = flight.inbound.arrivalTime
        inDepartureDate = flight.inbound.departureDate
        inDepartureTime = flight.inbound.departureTime
        inDestination = flight.inbound.destination
        inOrigin = flight.inbound.origin
        
        currency = flight.currency
        price = flight.price
    }
}

extension ManagedFlightDestination {
    func toDestination() -> FlightByPrice {
        
        return FlightByPrice(outDestination: outDestination!,
                             outOrigin: outOrigin!,
                             inDestination: inDestination!,
                             inOrigin: inOrigin!,
                             minPrice: price,
                             currency: currency!)
    }
    
    func fromFlightByPrice(flight: FlightByPrice) {
        price = flight.minPrice
        currency = flight.currency
        
        self.outDestination = flight.outDestination
        self.outOrigin = flight.outOrigin
        
        self.inDestination = flight.inDestination
        self.inOrigin = flight.inOrigin
    }
}

extension ManagedCurrency {
    func fromCurrency(currency: String, exchange: Currency) {
        value = exchange.exchangeRate
        self.currency = currency
    }
    
    func toCurrency() -> Currency {
        return Currency(currency: currency!, exchangeRate: value)
    }
}
