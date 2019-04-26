//
//  CurrencyDataStore.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import CoreData

protocol CurrencyDataStoreProtocol {
    func saveCurrency(currency: String, exchange: Currency, completionHandler: @escaping (_ result: FlightError?) -> Void)
    func fetchAll(completionHandler: @escaping (Result<[Currency], FlightError>) -> Void)
}

class CurrencyDataStore: DataStore, CurrencyDataStoreProtocol {
    func saveCurrency(currency: String, exchange: Currency, completionHandler: @escaping (_ result: FlightError?) -> Void) {
        self.context.privateManagedObjectContext.perform {
            do {
                let managedObj = ManagedCurrency(context: self.context.privateManagedObjectContext)
                managedObj.fromCurrency(currency: currency, exchange: exchange)
                
                try self.context.save()
                
                completionHandler(nil)
            } catch {
                completionHandler(FlightError.cannotSaveFlight("Cannot save flights"))
            }
        }
    }
    
    func fetchAll(completionHandler: @escaping (Result<[Currency], FlightError>) -> Void) {
        self.context.privateManagedObjectContext.perform {
            do {
                let request: NSFetchRequest<ManagedCurrency> = ManagedCurrency.fetchRequest()
                
                let currencies = try self.context.privateManagedObjectContext.fetch(request)
                completionHandler(Result.success(currencies.map{ $0.toCurrency() }))
            } catch {
                completionHandler(Result.failure(FlightError.cannotFetchCurrency(error.localizedDescription)))
            }
        }
    }
}
