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
}

protocol DestinationViewModelFactory {
    func makeDestinationViewModel() -> DestinationViewModelProtocol
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
            self.currencyRepository.fetchAll { [weak self] (result) in
                guard let self = self else { return }
                
                if case .success(let currencies) = result {
                    self.currencies = currencies.reduce(into: [:], {
                        $0[$1.currency] = $1.exchangeRate
                    })
                    
                    self.repository.fetchDestinations { [weak self] (result) in
                        guard let self = self else { return }
                        
                        if case .success(var flights) = result {
                            flights.sort(by: { (flight1, flight2) -> Bool in
                                return flight1.minPrice < flight2.minPrice
                            })
                            
                            self.datasource.value = flights
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
