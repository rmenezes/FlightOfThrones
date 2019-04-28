//
//  HomeViewModel.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

protocol HomeViewModelProtocol {
    var isBusy: Bindable<Bool> { get }
    var onError: Bindable<FlightOfThronesErrors> { get }
    func sync(completationHandler: @escaping (FlightOfThronesErrors?) -> Void)
}

class HomeViewModel: HomeViewModelProtocol {
    // MARK: Fields
    fileprivate let flightRepository: FlightRepositoryProtocol
    fileprivate let currencyRepository: CurrencyRepositoryProtocol
    
    // MARK: Properties
    var isBusy = Bindable<Bool>()
    var onError = Bindable<FlightOfThronesErrors>()
    
    init(flightRepository: FlightRepositoryProtocol, currencyRepository: CurrencyRepositoryProtocol) {
        self.flightRepository = flightRepository
        self.currencyRepository = currencyRepository
    }
    
    // MARK: HomeViewModelProtocol
    func sync(completationHandler: @escaping (FlightOfThronesErrors?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.isBusy.value = true
            
            self.flightRepository.sync { (error) in
                self.isBusy.value = false
                self.onError.value = error
            }
            
            self.currencyRepository.sync(completationHandler: { (error) in
                self.onError.value = error
            })
        }
    }
}
