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
    func fetchFlightOptions(forFlight flight: FlightByPrice, completationHandler: @escaping (Result<[Flight], FlightError>) -> Void)
}

class FlightRepository: FlightRepositoryProtocol {
    fileprivate let remoteService: FlightRemoteAPIProtocol
    fileprivate let dataStore: FlightDataStoreProtocol
    fileprivate let currencyDataStore: CurrencyDataStoreProtocol
    
    init(remoteService: FlightRemoteAPIProtocol, dataStore: FlightDataStoreProtocol, currencyDataStore: CurrencyDataStoreProtocol) {
        self.remoteService = remoteService
        self.dataStore = dataStore
        self.currencyDataStore = currencyDataStore
    }
    
    // MARK: FlightRepositoryProtocol
    func sync(completationHandler: @escaping (FlightError?) -> Void) {
        remoteService.fetchFlight { [weak self] (result) in
            guard let self = self else { return }
            
            if case .success(let flights) = result {
                self.saveFlights(flights, completationHandler: completationHandler)
            }
        }
    }
    
    func fetchDestinations(completationHandler: @escaping (Result<[FlightByPrice], FlightError>) -> Void) {        
        dataStore.fetchAllFlights { (result) in
            if case .success(let flights) = result {
                
                self.currencyDataStore.fetchAll(completionHandler: { (result) in
                    if case .success(let currencies) = result {
                        let rates = currencies.reduce(into: [:], {
                            $0[$1.currency] = $1.exchangeRate
                        })
                        
                        let eurFlights = flights.map({ (flight) -> Flight in
                            var fl = flight
                            fl.convertPriceToCurrencyIfNeeded(currencies: rates, currencyDestination: .eur)
                            return fl
                        })
                        
                        let destinationsGrouped = Dictionary(grouping: eurFlights, by: { item -> String in
                            return "\(item.outbound.origin) - \(item.outbound.destination)"
                        })
                        
                        let flightsByDestination = destinationsGrouped.map({ (item) -> FlightByPrice in
                            let minPrice = item.value.min(by: { (flight1, flight2) -> Bool in
                                return flight1.price < flight2.price
                            })!.price
                            
                            return FlightByPrice(outDestination: item.value[0].outbound.destination, outOrigin: item.value[0].outbound.origin, inDestination: item.value[0].inbound.destination, inOrigin: item.value[0].inbound.origin, minPrice: minPrice, currency: item.value[0].currency)
                        })
                        
                        completationHandler(Result.success(flightsByDestination))
                    } else if case .failure(let error) = result {
                        completationHandler(Result.failure(error))
                    }
                })
                
            } else if case .failure(let error) = result {
                completationHandler(Result.failure(error))
            }
        }
    }
    
    func fetchFlightOptions(forFlight flight: FlightByPrice, completationHandler: @escaping (Result<[Flight], FlightError>) -> Void) {
        dataStore.fetchByDestionation(destination: flight.outDestination, andOrigen: flight.outOrigin, completionHandler: completationHandler)
    }
    
    // MARK: Private
    fileprivate func saveFlights(_ flights: [Flight], completationHandler: @escaping (FlightError?) -> Void) {
        self.dataStore.saveFlights(flights: flights, completionHandler: completationHandler)
    }
}

enum FlightError: Error {
    case cannotFetchOnlineFlights(String)
    case cannotFetchCurrency(String)
    case cannotSaveFlight(String)
    case cannotSaveDestination(String)
    case cannotFeatchLocalFlights(String)
    case invalidResponseFormat(String)
}
