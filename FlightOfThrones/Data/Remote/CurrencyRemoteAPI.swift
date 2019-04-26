//
//  CurrencyRemoteAPI.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

protocol CurrencyRemoteApiProtocol {
    func fetchCurrency(from: CurrencyExchange, to: CurrencyExchange, completionHandler: @escaping (_ result: Result<Currency, FlightError>) -> Void)
}

class CurrencyRemoteAPI: NSObject, CurrencyRemoteApiProtocol {
    fileprivate var url: URLComponents?
    
    init(url: String) {
        self.url = URLComponents(string: url)
        super.init()
    }
    
    func fetchCurrency(from: CurrencyExchange, to: CurrencyExchange, completionHandler: @escaping (Result<Currency, FlightError>) -> Void) {
        guard var url = self.url else { return }
        
        var queryParams = [URLQueryItem]()
        queryParams.append(URLQueryItem(name: "from", value: from.rawValue))
        queryParams.append(URLQueryItem(name: "to", value: to.rawValue))
        url.queryItems = queryParams
        
        let task = URLSession.shared.dataTask(with: url.url!) { (data, response, error) in
            guard let dataResponse = data, error == nil else {
                completionHandler(Result.failure(FlightError.cannotFetchCurrency(error.debugDescription)))
                return
            }
            
            do {
                let currency = try JSONDecoder().decode(Currency.self, from: dataResponse)
                completionHandler(Result.success(currency))
            } catch {
                completionHandler(Result.failure(FlightError.invalidResponseFormat(error.localizedDescription)))
            }
        }
        
        task.resume()
    }
}
