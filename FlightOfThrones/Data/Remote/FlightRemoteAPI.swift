//
//  FlightService.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/25/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

protocol FlightRemoteAPIProtocol {
    func fetchFlight(completionHandler: @escaping (_ result: Result<[Flight], FlightError>) -> Void)
}

class FlightRemoteAPI: NSObject, FlightRemoteAPIProtocol {
    fileprivate var url: URL?
    
    init(url: String) {
        self.url = URL(string: url)
        super.init()
    }
    
    // MARK: FlightProtocol
    func fetchFlight(completionHandler: @escaping (_ result: Result<[Flight], FlightError>) -> Void) {
        guard let url = self.url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                completionHandler(Result.failure(FlightError.cannotFetchOnlineFlights(error.debugDescription)))
                return
            }
            
            do {
                let flights = try JSONDecoder().decode(FlightResponse.self, from: dataResponse)
                completionHandler(Result.success(flights.results))
            } catch {
                completionHandler(Result.failure(FlightError.invalidResponseFormat(error.localizedDescription)))
            }
        }
        
        task.resume()
    }
}
