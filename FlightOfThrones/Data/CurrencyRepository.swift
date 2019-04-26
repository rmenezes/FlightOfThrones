//
//  CurrencyRepository.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//
import CoreData

protocol CurrencyRepositoryProtocol {
    func sync(completationHandler: @escaping (FlightError?) -> Void)
    func fetchGBP(completationHandler: @escaping (FlightError?) -> Void)
    func fetchJPY(completationHandler: @escaping (FlightError?) -> Void)
    func fetchUSD(completationHandler: @escaping (FlightError?) -> Void)
    func fetchAll(completationHandler: @escaping (Result<[Currency], FlightError>) -> Void)
}

class CurrencyRepository: CurrencyRepositoryProtocol {
    fileprivate let remoteService: CurrencyRemoteApiProtocol
    fileprivate let dataStore: CurrencyDataStoreProtocol
    
    init(remoteService: CurrencyRemoteApiProtocol, dataStore: CurrencyDataStoreProtocol) {
        self.remoteService = remoteService
        self.dataStore = dataStore
    }
    
    // MARK: CurrencyRepositoryProtocol
    func sync(completationHandler: @escaping (FlightError?) -> Void) {
        // GBP -> EUR
        fetchGBP(completationHandler: completationHandler)
        // JPN -> EUR
        fetchJPY(completationHandler: completationHandler)
        // USD -> EUR
        fetchUSD(completationHandler: completationHandler)
    }
    
    func fetchGBP(completationHandler: @escaping (FlightError?) -> Void) {
        self.remoteService.fetchCurrency(from: .gbp, to: .eur) { (result) in
            if case .success(let currency) = result {
                print(currency)
                self.dataStore.saveCurrency(currency: CurrencyExchange.gbp.rawValue, exchange: currency, completionHandler: completationHandler)
            } else if case .failure(let error) = result {
                completationHandler(error)
            }
        }
    }
    
    func fetchJPY(completationHandler: @escaping (FlightError?) -> Void) {
        self.remoteService.fetchCurrency(from: .jpy, to: .eur) { (result) in
            if case .success(let currency) = result {
                print(currency)
                self.dataStore.saveCurrency(currency: CurrencyExchange.jpy.rawValue, exchange: currency, completionHandler: completationHandler)
            } else if case .failure(let error) = result {
                completationHandler(error)
            }
        }
    }
    
    func fetchUSD(completationHandler: @escaping (FlightError?) -> Void) {
        self.remoteService.fetchCurrency(from: .usd, to: .eur) { (result) in
            if case .success(let currency) = result {
                print(currency)
                self.dataStore.saveCurrency(currency: CurrencyExchange.usd.rawValue, exchange: currency, completionHandler: completationHandler)
            } else if case .failure(let error) = result {
                completationHandler(error)
            }
        }
    }
    
    func fetchAll(completationHandler: @escaping (Result<[Currency], FlightError>) -> Void) {
        dataStore.fetchAll(completionHandler: completationHandler)
    }
}

enum CurrencyExchange: String {
    case gbp = "GBP"
    case jpy = "JPY"
    case usd = "USD"
    case eur = "EUR"
}
