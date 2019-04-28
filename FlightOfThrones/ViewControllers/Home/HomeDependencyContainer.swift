//
//  HomeDependencyContainer.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

class HomeDependencyContainer {
    let flightRepository: FlightRepositoryProtocol
    let currencyRepository: CurrencyRepositoryProtocol
    
    
    init(appDependencyContainer: FlightOfThronesAppDependencyContainer) {
        self.flightRepository = appDependencyContainer.sharedFlightRepository
        self.currencyRepository = appDependencyContainer.sharedCurrencyRepository
    }
}

// MARK: Destinations
extension HomeDependencyContainer: HomeViewControllerFactory {
    func makeDetinationsViewController() -> DestinationViewController {
        return DestinationViewController(viewModel: makeDestinationViewModel(), viewControllerFactory: self)
    }
}

extension HomeDependencyContainer: DestinationViewModelFactory {
    func makeDestinationViewModel() -> DestinationViewModelProtocol {
        return DestinationViewModel(repository: flightRepository, currencyRepository: currencyRepository)
    }
}

// MARK: Flight Options
extension HomeDependencyContainer: DestinationViewControllerFactory {
    func makeFlightOptionsViewController(withDestination: FlightByPrice) -> FlightOptionsViewController {
        return FlightOptionsViewController(viewModel: makeFlightOptionsViewModel(), destination: withDestination)
    }
}

extension HomeDependencyContainer: FlightOptionsViewModelFactory {
    func makeFlightOptionsViewModel() -> FlightOptionsViewModelProtocol {
        return FlightOptionsViewModel(repository: flightRepository, currencyRepository: currencyRepository)
    }
}
