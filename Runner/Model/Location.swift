//
//  Location.swift
//  Runner
//
//  Created by Vahit Emre TELLİER on 25.01.2022.
//

import Foundation
import RealmSwift

class Location : Object {
    @objc dynamic var latitude = 0.0
    @objc dynamic var longitude = 0.0
    
    convenience init(latitude : Double, longitude : Double) {
        self.init()
        self.latitude = latitude
        self.longitude = longitude
    }
}
