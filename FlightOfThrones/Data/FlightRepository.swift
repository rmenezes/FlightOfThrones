//
//  FlightRepository.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

protocol FlightRepositoryProtocol {
    func sync(completationHandler: @escaping (FlightError?) -> Void)
    func fetchDestinations(completationHandler: @escaping (Result<[FlightByPrice], FlightError>) -> Void)
}

class FlightRepository: FlightRepositoryProtocol {
    fileprivate let remoteService: FlightRemoteAPIProtocol
    fileprivate let dataStore: FlightDataStoreProtocol
    
    init(remoteService: FlightRemoteAPIProtocol, dataStore: FlightDataStoreProtocol) {
        self.remoteService = remoteService
        self.dataStore = dataStore
    }
    
    // MARK: FlightRepositoryProtocol
    func sync(completationHandler: @escaping (FlightError?) -> Void) {
        remoteService.fetchFlight { [weak self] (result) in
            guard let self = self else { return }
            
            if case .success(let flights) = result {
                self.saveGroupedByDestination(flights, completationHandler: completationHandler)
                self.saveFlights(flights, completationHandler: completationHandler)
            }
        }
    }
    
    func fetchDestinations(completationHandler: @escaping (Result<[FlightByPrice], FlightError>) -> Void) {
        dataStore.fetch(completionHandler: completationHandler)
    }
    
    // MARK: Private
    fileprivate func saveFlights(_ flights: [Flight], completationHandler: @escaping (FlightError?) -> Void) {
        self.dataStore.saveFlights(flights: flights, completionHandler: completationHandler)
    }
    
    fileprivate func saveGroupedByDestination(_ flights: [Flight], completationHandler: @escaping (FlightError?) -> Void) {
        
        let destinationsGrouped = Dictionary(grouping: flights, by: { item -> String in
            return "\(item.outbound.origin) - \(item.outbound.destination) / \(item.inbound.origin) - \(item.inbound.destination)"
        })
        
        let flightsByDestination = destinationsGrouped.map({ (item) -> FlightByPrice in
            let minPrice = item.value.min(by: { (flight1, flight2) -> Bool in
                return flight1.price < flight2.price
            })!.price
            
            return FlightByPrice(outDestination: item.value[0].outbound.destination, outOrigin: item.value[0].outbound.origin, inDestination: item.value[0].inbound.destination, inOrigin: item.value[0].inbound.origin, minPrice: minPrice)
        })
        
        self.dataStore.saveDestinations(flights: flightsByDestination, completionHandler: completationHandler )
    }
}

enum FlightError: Error {
    case cannotFetchOnlineFlights(String)
    case cannotSaveFlight(String)
    case cannotSaveDestination(String)
    case cannotFeatchLocalFlights(String)
    case invalidResponseFormat(String)
}
