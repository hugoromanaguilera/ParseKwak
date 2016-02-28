//
//  Annotation.swift
//  ParseKwak
//
//  Created by hugo roman on 10/30/15.
//  Copyright © 2015 Parse. All rights reserved.
//


import Foundation
import Parse

class Annotation{
    
    var id = ""
    var sucursalId : Sucursales!
    var peopleAtPosition : Int
    var positionType = ""
    var me : PFObject?
    
    init(idIn: String, sucursalIdIn: Sucursales!, peopleAtPositionIn: Int, positionTypeIn:String, meIn: PFObject){
        self.id = idIn
        self.sucursalId = sucursalIdIn
        self.peopleAtPosition = peopleAtPositionIn
        self.positionType = positionTypeIn
        self.me = meIn
    }
    
}
