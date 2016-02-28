//
//  Sucursales.swift
//  BasicParse
//
//  Created by hugo roman on 10/21/15.
//  Copyright © 2015 Parse. All rights reserved.
//

import Foundation
import Parse

class Sucursales{

    var id = ""
    var address = ""
    var city = ""
    var position = CLLocation()
    var sucursalType = ""
    var peopleAtCashier = 0
    var peopleAtCustomerService = 0
    var me : PFObject?
    
    
    /*
     * INICIALIZADORES
     */
    
    init(){}
    
    init(idIn: String, addressIn: String, cityIn: String , positionIn:CLLocation, sucursalTypeIn:String, atCashier: Int, atCustomerService: Int, meIn: PFObject){
        self.id = idIn
        self.address = addressIn
        self.city = cityIn
        self.position = positionIn
        self.sucursalType = sucursalTypeIn
        self.peopleAtCashier = atCashier
        self.peopleAtCustomerService = atCustomerService
        self.me = meIn
    }

}
