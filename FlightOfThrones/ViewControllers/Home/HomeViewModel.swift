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
    func sync(completationHandler: @escaping (FlightError?) -> Void)
}

class HomeViewModel: HomeViewModelProtocol {
    // MARK: Fields
    fileprivate let flightRepository: FlightRepositoryProtocol
    fileprivate let currencyRepository: CurrencyRepositoryProtocol
    
    // MARK: Properties
    var isBusy = Bindable<Bool>()
    
    init(flightRepository: FlightRepositoryProtocol, currencyRepository: CurrencyRepositoryProtocol) {
        self.flightRepository = flightRepository
        self.currencyRepository = currencyRepository
    }
    
    // MARK: HomeViewModelProtocol
    func sync(completationHandler: @escaping (FlightError?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.isBusy.value = true
            
            self.flightRepository.sync { (error) in
                self.isBusy.value = false
            }
            
            self.currencyRepository.sync(completationHandler: { (error) in
                
            })
        }
    }
}
