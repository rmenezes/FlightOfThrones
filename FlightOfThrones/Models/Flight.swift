//
//  Flight.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

struct FlightResponse: Decodable {
    var results: [Flight]
}

struct Flight: Decodable {
    var price: Double
    var currency: String
    let inbound: DragonFlight
    let outbound: DragonFlight
}

struct DragonFlight: Decodable {
    let airline: String
    let airlineImage: String
    let arrivalDate: String
    let arrivalTime: String
    let departureDate: String
    let departureTime: String
    let destination: String
    let origin: String
}

struct FlightByPrice {
    let outDestination: String
    let outOrigin: String
    let inDestination: String
    let inOrigin: String
    var minPrice: Double
    var currency: String
}
