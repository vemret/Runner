//
//  LocationViewController.swift
//  Runner
//
//  Created by Vahit Emre TELLİER on 19.01.2022.
//

import UIKit
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {

    var manager : CLLocationManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = CLLocationManager()
        manager?.desiredAccuracy = kCLLocationAccuracyBest
//        koşu için fitness seçildi. manager ona göre takip edecek
        manager?.activityType = .fitness

        // Do any additional setup after loading the view.
    }
    
//    Eğer kunum izni verilmemişse tekrar iste
    func permissionCtrl(){
        
//        ios 14 ile gelen günceleme için        
        if #available(iOS 14.0, *) {
            if CLLocationManager().authorizationStatus != .authorizedWhenInUse{
                manager?.requestWhenInUseAuthorization()
            }
        } else {
            if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
                manager?.requestWhenInUseAuthorization()
            }
        }
        
    }

}
