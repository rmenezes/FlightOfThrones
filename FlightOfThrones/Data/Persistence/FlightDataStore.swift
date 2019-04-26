//
//  FlightDataStore.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//
import CoreData

protocol FlightDataStoreProtocol: class {
    func saveFlights(flights: [Flight], completionHandler: @escaping (_ result: FlightError?) -> Void)
    func saveDestinations(flights: [FlightByPrice], completionHandler: @escaping (_ result: FlightError?) -> Void)
    func fetch(completionHandler: @escaping (_ result: Result<[FlightByPrice], FlightError>) -> Void)
    func fetchByDestionation(destination: String, andOrigen origen: String, completionHandler: @escaping (_ result: Result<[Flight], FlightError>) -> Void)
}

class FlightDataStore: DataStore, FlightDataStoreProtocol {
    func saveFlights(flights: [Flight], completionHandler: @escaping (_ result: FlightError?) -> Void) {
        self.context.privateManagedObjectContext.perform {
            do {
                flights.forEach { flight in
                    let managedObj = ManagedFlight(context: self.context.privateManagedObjectContext)
                    managedObj.fromFlight(flight: flight)
                }
                
                try self.context.save()
                
                completionHandler(nil)
            } catch {
                completionHandler(FlightError.cannotSaveFlight("Cannot save flights"))
            }
        }
    }
    
    func saveDestinations(flights: [FlightByPrice], completionHandler: @escaping (FlightError?) -> Void) {
        self.context.privateManagedObjectContext.perform {
            do {
                flights.forEach { flight in
                    let managedObj = ManagedFlightDestination(context: self.context.privateManagedObjectContext)
                    managedObj.fromFlightByPrice(flight: flight)
                }
                
                try self.context.save()
                
                completionHandler(nil)
            } catch {
                completionHandler(FlightError.cannotSaveDestination("Cannot save destination"))
            }
        }
    }
    
    func fetch(completionHandler: @escaping (_ result: Result<[FlightByPrice], FlightError>) -> Void) {
        self.context.privateManagedObjectContext.perform {
            do {
                let request: NSFetchRequest<ManagedFlightDestination> = ManagedFlightDestination.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
                
                let destinations = try self.context.privateManagedObjectContext.fetch(request)
                completionHandler(Result.success(destinations.map{ $0.toDestination() }))
            } catch {
                completionHandler(Result.failure(FlightError.cannotFeatchLocalFlights("Cannot fetch flights")))
            }
        }
    }
    
    func fetchByDestionation(destination: String, andOrigen origen: String, completionHandler: @escaping (_ result: Result<[Flight], FlightError>) -> Void){
        self.context.privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedFlight")
                let results = try self.context.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedFlight]
                let flights = results.map { $0.toFlight() }
                completionHandler(Result.success(flights))
            } catch {
                completionHandler(Result.failure(FlightError.cannotFeatchLocalFlights("Cannot fetch flights")))
            }
        }
    }
}
