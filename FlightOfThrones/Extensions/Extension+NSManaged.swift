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
        let outbound = destination!.split(separator: "-")
        let inbound = origin!.split(separator: "-")
        
        return FlightByPrice(outDestination: String(outbound[0].trimmingCharacters(in: .whitespaces)),
                             outOrigin: String(outbound[1].trimmingCharacters(in: .whitespaces)),
                             inDestination: String(inbound[0].trimmingCharacters(in: .whitespaces)),
                             inOrigin: String(inbound[1].trimmingCharacters(in: .whitespaces)),
                             minPrice: price)
    }
    
    func fromFlightByPrice(flight: FlightByPrice) {
        price = flight.minPrice
        destination = "\(flight.outOrigin) - \(flight.inDestination)"
        origin = "\(flight.inOrigin) - \(flight.inDestination)"
    }
}
