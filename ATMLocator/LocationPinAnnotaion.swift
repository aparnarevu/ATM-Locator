//
//  LocationPinAnnotaion.swift
//  ATMLocator
//
//  Created by Aparna Revu on 3/5/17.
//  Copyright © 2017 Aparna Revu. All rights reserved.
//

import Foundation
import MapKit

class LocationPinAnnotaion : MKPointAnnotation
{
    var atmLocationInfo:ATMInfo!
    
    init(atmLocationInfo:ATMInfo) {
        self.atmLocationInfo = atmLocationInfo

    }

}
