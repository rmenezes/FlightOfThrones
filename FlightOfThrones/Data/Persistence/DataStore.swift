//
//  DataStore.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/26/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import CoreData

class DataStore {
    // MARK: - Managed object contexts
    var context: FlightContext
    
    init(context: FlightContext) {
        self.context = context
    }
}
