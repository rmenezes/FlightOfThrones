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

class FlightDataStore: FlightDataStoreProtocol {
    // MARK: - Managed object contexts
    var mainManagedObjectContext: NSManagedObjectContext
    var privateManagedObjectContext: NSManagedObjectContext
    
    init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "FlightOfThrones", withExtension: "momd") else {
            fatalError("Error loading model from bundle")
        }
        
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        mainManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainManagedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("FlightOfThrones")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
        privateManagedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateManagedObjectContext.parent = mainManagedObjectContext
    }
    
    deinit {
        do {
            try self.mainManagedObjectContext.save()
        } catch {
            fatalError("Error deinitializing main managed object context")
        }
    }
    
    func saveFlights(flights: [Flight], completionHandler: @escaping (_ result: FlightError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                flights.forEach { flight in
                    let managedObj = ManagedFlight(context: self.privateManagedObjectContext)
                    managedObj.fromFlight(flight: flight)
                }
                
                try self.privateManagedObjectContext.save()
                
                completionHandler(nil)
            } catch {
                completionHandler(FlightError.cannotSaveFlight("Cannot save flights"))
            }
        }
    }
    
    func saveDestinations(flights: [FlightByPrice], completionHandler: @escaping (FlightError?) -> Void) {
        privateManagedObjectContext.perform {
            do {
                flights.forEach { flight in
                    let managedObj = ManagedFlightDestination(context: self.privateManagedObjectContext)
                    managedObj.fromFlightByPrice(flight: flight)
                }
                
                try self.privateManagedObjectContext.save()
                
                completionHandler(nil)
            } catch {
                completionHandler(FlightError.cannotSaveDestination("Cannot save destination"))
            }
        }
    }
    
    func fetch(completionHandler: @escaping (_ result: Result<[FlightByPrice], FlightError>) -> Void) {
        privateManagedObjectContext.perform {
            do {
                let request: NSFetchRequest<ManagedFlightDestination> = ManagedFlightDestination.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(key: "price", ascending: true)]
                
                let destinations = try self.privateManagedObjectContext.fetch(request)
                completionHandler(Result.success(destinations.map{ $0.toDestination() }))
            } catch {
                completionHandler(Result.failure(FlightError.cannotFeatchLocalFlights("Cannot fetch flights")))
            }
        }
    }
    
    func fetchByDestionation(destination: String, andOrigen origen: String, completionHandler: @escaping (_ result: Result<[Flight], FlightError>) -> Void){
        privateManagedObjectContext.perform {
            do {
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ManagedFlight")
                let results = try self.privateManagedObjectContext.fetch(fetchRequest) as! [ManagedFlight]
                let flights = results.map { $0.toFlight() }
                completionHandler(Result.success(flights))
            } catch {
                completionHandler(Result.failure(FlightError.cannotFeatchLocalFlights("Cannot fetch flights")))
            }
        }
    }
}
