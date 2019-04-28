//
//  FlightOptionsViewModel.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/28/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

protocol FlightOptionsViewModelProtocol {
    var isBusy: Bindable<Bool> { get }
    var onError: Bindable<FlightError> { get }
    var datasource: Bindable<[Flight]> { get }
    var currencies: [String: Double] { get }
    
    func loadData(withFlightOptions flight: FlightByPrice)
}

protocol FlightOptionsViewModelFactory {
    func makeFlightOptionsViewModel() -> FlightOptionsViewModelProtocol
}

class FlightOptionsViewModel: FlightOptionsViewModelProtocol {
    // MARK: Fields
    fileprivate let repository: FlightRepositoryProtocol
    fileprivate let currencyRepository: CurrencyRepositoryProtocol
    
    // MARK: Properties
    var isBusy = Bindable<Bool>()
    var onError = Bindable<FlightError>()
    var datasource = Bindable<[Flight]>()
    var currencies = [String: Double]()
    
    init(repository: FlightRepositoryProtocol, currencyRepository: CurrencyRepositoryProtocol) {
        self.repository = repository
        self.currencyRepository = currencyRepository
    }
    
    // MARK: FlightOptionsViewModelProtocol
    func loadData(withFlightOptions flight: FlightByPrice) {
        DispatchQueue.global(qos: .background).async {
            self.currencyRepository.fetchAll { [weak self] (result) in
                guard let self = self else { return }
                
                if case .success(let currencies) = result {
                    self.currencies = currencies.reduce(into: [:], {
                        $0[$1.currency] = $1.exchangeRate
                    })
                    
                    self.repository.fetchFlightOptions(forFlight: flight) { [weak self] (result) in
                        guard let self = self else { return }
                        
                        if case .success(let flights) = result {
                            var flPrice = flights.map({ (flight) -> Flight in
                                var fl = flight
                                fl.convertPriceToCurrencyIfNeeded(currencies: self.currencies, currencyDestination: .eur)
                                return fl
                            })
                            
                            flPrice.sort(by: { (flight1, flight2) -> Bool in
                                return flight1.price < flight2.price
                            })
                            
                            self.datasource.value = flPrice
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
}
