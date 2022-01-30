//
//  StartToRunViewController.swift
//  Runner
//
//  Created by Vahit Emre TELLİER on 19.01.2022.
//

import UIKit
import MapKit
import RealmSwift

// LocationViewController UIViewControllerdan türetildiği için StartToRunViewController: LocationViewController sorun yok. LocationViewController içindeki fonksiyonlar, mapview vs kullanılıabilecek.
class StartToRunViewController: LocationViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var paceLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var lastRunStack: UIStackView!
    @IBOutlet weak var lastRunView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        permissionCtrl()
        mapView.delegate = self
        
        print("All of the runs : \(RunModel.getAllRunHistory())")
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
//        sayfa açıldığında konum bilgisini güncellemeye başla
        manager?.startUpdatingLocation()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        manager?.delegate = self
//        sayfa kapatıldığında konum bilgisini güncellemeyi durdur
        manager?.stopUpdatingLocation()
        
    }
    
    
//    ststus içinde kullanıcının izin bilgileri mevcut
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            permissionCtrl()
//            konum değeri görüntüle
            mapView.showsUserLocation = true

        }
    }
    

    @IBAction func goToUserBtnClicked(_ sender: Any) {
        userBasePositionMapView()
    }
    
//    koşu çizim,ni kapsıyacak map odaklaması
    func runZonePositions(positions : List<Location>) -> MKCoordinateRegion {
        guard let beginOfPositions =  positions.first else {
            return MKCoordinateRegion()
        }
        
        var minLat = beginOfPositions.latitude
        var maxLat = minLat
        
        var minLong = beginOfPositions.longitude
        var maxLong = minLong
        
        
        for position in positions {
            minLat = min(minLat, position.latitude)
            maxLat = max(maxLat, position.latitude)
            
            minLong = min(minLong, position.longitude)
            maxLong = max(maxLong, position.longitude)
        }
        
        return MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: (minLat + maxLat)/2, longitude: (minLong+maxLong)/2), span: MKCoordinateSpan(latitudeDelta: (maxLat-minLat)*2, longitudeDelta: (maxLong-minLong)*2))
    }
    
//   kullanıcının konumuna odaklanma
    func userBasePositionMapView() {
        mapView.userTrackingMode = .follow
        
        let fieldCoordinate = MKCoordinateRegion(center: mapView.userLocation.coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
        mapView.setRegion(fieldCoordinate, animated: true)
    }

    
    @IBAction func closeBtnClicked(_ sender: Any) {
//       kapata a basıldıysa görünumleri gizle
        lastRunStack.isHidden = true
        lastRunView.isHidden = true
        closeButton.isHidden = true
//        kullanıcı son kosu bilgilerini kapattığında her hangi bir bilgi görmek istemiyor
//        kullanıcnın konumu gösterilecek
        userBasePositionMapView()
    }
    
    
//    haritadaki çizggi için
    func addLastRunMap() -> MKPolyline? {
        
        guard let lastRun = RunModel.getAllRunHistory()?.first else {
            return nil
        }
        
        distanceLabel.text = "Distance : \(String(format: "%.2f", lastRun.distance))"
        timeLabel.text = "Time : \(lastRun.time.counterToSecond())"
        paceLabel.text = "Pace : \(lastRun.pace.counterToSecond())"
        
        
//      MKPolyline CLLocationCoordinate2D nesnesi istediği için
        var coordinates = [CLLocationCoordinate2D]()
        
        for position in lastRun.locations {
            coordinates.append(CLLocationCoordinate2D(latitude: position.latitude, longitude: position.longitude))
        }
        
//        son koşu haritaya ekleniyorsa kullanıcının konumunu takip etmeye gerek yok
        mapView.userTrackingMode = .none
        mapView.setRegion(runZonePositions(positions: lastRun.locations), animated: true)
        
        return MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
//    sayfadaki labeller görüntülesinsin mapviewe sonra çizdirilsin
    override func viewDidAppear(_ animated: Bool) {
        setMapView()
    }
    
    
    func setMapView(){
        if let overlay = addLastRunMap() {
//            eğer sıfırdan büyükse bir çizim vardır
            if mapView.overlays.count > 0 {
                mapView.removeOverlays(mapView.overlays)
            }
//            eğer çizim yoksa, varsada temizlendi yukarda
            mapView.addOverlay(overlay)
            
            lastRunStack.isHidden = false
            lastRunView.isHidden = false
            closeButton.isHidden = false
        } else {
//            bilgiler gelmediyse görünumleri gizle
            lastRunStack.isHidden = true
            lastRunView.isHidden = true
            closeButton.isHidden = true
//            kullanıcının son konumunu göster
        }
    }

    
    
//    haritada kuşulan mesafeyi çizdirmek için
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 6
        return renderer
    }
    

}
