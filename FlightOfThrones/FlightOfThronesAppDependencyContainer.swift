//
//  FlightOfThronesAppDependencyContainer.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

class FlightOfThronesAppDependencyContainer {
    // Long-lived dependencies
    let sharedFlightRepository: FlightRepositoryProtocol
    let sharedCurrencyRepository: CurrencyRepositoryProtocol
    
    init() {
        let context = FlightContext()
        
        func makeFlightRepository() -> FlightRepositoryProtocol {
            let flightStore = makeFlightStore()
            let flightApi = makeFlightApi()
            return FlightRepository(remoteService: flightApi, dataStore: flightStore)
        }
        
        func makeCurrencyRepository() -> CurrencyRepositoryProtocol {
            let currencyStore = makeCurrencyStore()
            let currencyApi = makeCurrencyApi()
            return CurrencyRepository(remoteService: currencyApi, dataStore: currencyStore)
        }
        
        func makeFlightStore() -> FlightDataStoreProtocol {
            return FlightDataStore(context: context)
        }
        
        func makeFlightApi() -> FlightRemoteAPIProtocol {
            return FlightRemoteAPI(url: Endpoints.kFlights)
        }
        
        func makeCurrencyStore() -> CurrencyDataStoreProtocol {
            return CurrencyDataStore(context: context)
        }
        
        func makeCurrencyApi() -> CurrencyRemoteApiProtocol {
            return CurrencyRemoteAPI(url: Endpoints.kCurrency)
        }
        
        self.sharedFlightRepository = makeFlightRepository()
        self.sharedCurrencyRepository = makeCurrencyRepository()
    }
    
    // Home
    func makeHomeDependencyContainer() -> HomeDependencyContainer {
        return HomeDependencyContainer(appDependencyContainer: self)
    }
    
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(flightRepository: sharedFlightRepository, currencyRepository: sharedCurrencyRepository)
    }
    
    func makeHomeViewController() -> HomeViewController {
        return HomeViewController(viewModel: makeHomeViewModel(), viewControllerFactory: makeHomeDependencyContainer())
    }
}
