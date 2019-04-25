//
//  HomeViewModel.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

protocol HomeViewModelProtocol {
    func sync(completationHandler: @escaping (FlightError?) -> Void)
}

class HomeViewModel: HomeViewModelProtocol {
    // MARK: Fields
    fileprivate let repository: FlightRepositoryProtocol
    
    // MARK: Properties
    var isBusy = Bindable<Bool>()
    
    init(repository: FlightRepositoryProtocol) {
        self.repository = repository
    }
    
    // MARK: HomeViewModelProtocol
    func sync(completationHandler: @escaping (FlightError?) -> Void) {
        isBusy.value = true
        
        self.repository.sync { (error) in
            self.isBusy.value = false
        }
    }
}
