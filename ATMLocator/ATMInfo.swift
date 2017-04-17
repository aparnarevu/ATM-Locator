//
//  ATMInfo.swift
//  ATMLocator
//
//  Created by Aparna Revu on 3/5/17.
//  Copyright © 2017 Aparna Revu. All rights reserved.
//

import Foundation

class ATMInfo {
    
    var name:String? = ""
    var phone:String? = ""
    var zip:String? = ""
    var distance:Double? = 0.0
    var address:String? = ""
    var state:String? = ""
    var city:String? = ""
    var lobbyHours:[Any]? = []
    
    
    func addressDetails() -> String {
        
        let fullAddress = "\(self.address!) \n \(self.city!) , \(self.state!) , \(self.zip!) "
        return fullAddress
    }
    
}
