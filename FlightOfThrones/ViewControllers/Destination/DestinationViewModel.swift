//
//  DestinationViewModel.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

protocol DestinationViewModelProtocol {
    var isBusy: Bindable<Bool> { get }
    var onError: Bindable<FlightError> { get }
    var datasource: Bindable<[FlightByPrice]> { get }
    var currencies: [String: Double] { get }
    
    func loadData()
    func convertPriceToCurrencyIfNeeded(flight: inout FlightByPrice, currencyDestination: CurrencyExchange)
}

class DestinationViewModel: DestinationViewModelProtocol {
    // MARK: Fields
    fileprivate let repository: FlightRepositoryProtocol
    fileprivate let currencyRepository: CurrencyRepositoryProtocol
    
    // MARK: Properties
    var isBusy = Bindable<Bool>()
    var onError = Bindable<FlightError>()
    var datasource = Bindable<[FlightByPrice]>()
    var currencies = [String: Double]()
    
    init(repository: FlightRepositoryProtocol, currencyRepository: CurrencyRepositoryProtocol) {
        self.repository = repository
        self.currencyRepository = currencyRepository
    }
    
    // MARK: DestinationViewModelProtocol
    
    func loadData() {
        DispatchQueue.global(qos: .background).async {
            self.currencyRepository.fetchAll { (result) in
                if case .success(let currencies) = result {
                    self.currencies = currencies.reduce(into: [:], {
                        $0[$1.currency] = $1.exchangeRate
                    })
                    
                    self.repository.fetchDestinations { (result) in
                        if case .success(let flights) = result {
                            var flByPrice = flights.map({ (flight) -> FlightByPrice in
                                var fl = flight
                                self.convertPriceToCurrencyIfNeeded(flight: &fl, currencyDestination: .eur)
                                return fl
                            })
                            
                            flByPrice.sort(by: { (flight1, flight2) -> Bool in
                                return flight1.minPrice < flight2.minPrice
                            })
                            
                            self.datasource.value = flByPrice
                        } else if case .failure(let error) = result {
                            self.onError.value = error
                        }
                    }
                } else if case .failure(let error) = result {
                    self.onError.value = error
                }
            }
        }
    }
    
    @inlinable func convertPriceToCurrencyIfNeeded(flight: inout FlightByPrice, currencyDestination: CurrencyExchange) {
        if flight.currency == currencyDestination.rawValue {
            return
        }
        
        flight.minPrice = flight.minPrice / currencies[flight.currency]!
        flight.currency = currencyDestination.rawValue
    }
}
