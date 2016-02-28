//
//  myParseUtils.swift
//  ParseKwak
//
//  Created by hugo roman on 10/31/15.
//  Copyright © 2015 Parse. All rights reserved.
//
import Parse
extension PFGeoPoint {
    
    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude, longitude: self.longitude)
    }
}

