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
    
    // Destination
    func makeDestinationViewModel() -> DestinationViewModel {
        return DestinationViewModel(repository: flightRepository, currencyRepository: currencyRepository)
    }
}

extension HomeDependencyContainer: HomeViewControllerFactory {
    func makeDetinationsViewController() -> DestinationViewController {
        return DestinationViewController(viewModel: makeDestinationViewModel(), viewControllerFactory: self)
    }
}

extension HomeDependencyContainer: DestinationViewControllerFactory {
    func makeFlightOptionsViewController() -> UIViewController {
        return UIViewController()
    }
}
