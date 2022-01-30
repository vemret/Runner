//
//  RunModel.swift
//  Runner
//
//  Created by Vahit Emre TELLİER on 23.01.2022.
//

import Foundation
import RealmSwift

class RunModel : Object {
    
    @objc dynamic var id = ""
    @objc dynamic var date = NSDate()
    @objc dynamic var pace = 0
    @objc dynamic var distance = 0.0
    @objc dynamic var time = 0
    dynamic var locations = List<Location>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func indexedProperties() -> [String] {
        return ["date", "pace", "time"]
    }
    
//    list Realm' a ozel kullanılabilir.
    convenience init(pace : Int, time : Int, distance : Double, locations : List<Location>) {
        
        self.init()
        self.id = UUID().uuidString.lowercased()
        self.date = NSDate()
        self.pace = pace
        self.distance = distance
        self.time = time
        self.locations = locations
    }
    
    static func addRunRealm(time : Int, distance : Double, pace : Int, locations : List<Location>){
        
        REALM_QUERY.sync {
            
        
        
            let run = RunModel(pace: pace, time: time, distance: distance, locations: locations)
            
            do{
                let realm = try Realm()
                try realm.write({
                    realm.add(run)
                    try realm.commitWrite()
                    print("data successfully added")
                })
                
            }catch{
                print("There is an Error ; \(error.localizedDescription)")
            }
        }
    }
    
    static func getAllRunHistory() -> Results<RunModel>? {
        
        do {
            let realm = try Realm()
            var runings = realm.objects(RunModel.self)
            runings = runings.sorted(byKeyPath: "date", ascending: false)
            return runings
        } catch {
            print("ther is an Error! : \(error.localizedDescription)")
            return nil
        }
    }
    
    
}
