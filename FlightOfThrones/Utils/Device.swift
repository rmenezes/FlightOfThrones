//
//  Device.swift
//  FlightOfThrones
//
//  Created by Raul Menezes on 4/28/19.
//  Copyright © 2019 Raul Menezes. All rights reserved.
//

import UIKit

class Device {
    class func isIPad() -> Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
