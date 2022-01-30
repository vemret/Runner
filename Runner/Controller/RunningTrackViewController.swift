//
//  ViewController.swift
//  Runner
//
//  Created by Vahit Emre TELLİER on 19.01.2022.
//

import UIKit
import MapKit
import RealmSwift

class RunningTrackViewController: LocationViewController, CLLocationManagerDelegate {

    @IBOutlet weak var imgRunningFinish: UIImageView!
    @IBOutlet weak var btnRunningFinish: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempoLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var btnStop: UIButton!
    
    var distanceOfRunning : Double = 0.0
    var firstLocation : CLLocation!
    var lastLocation : CLLocation!
    var counter : Int = 0
    var timer = Timer()
    var pace = 0
    var positions = List<Location>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
//        koşuyu bitirmek için swipe butonuna dokunma yeteneği veriliyor
        let swipeGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(finishTheRun(sender:)))
        btnRunningFinish.addGestureRecognizer(swipeGestureRecognizer)
//        kullanıcı buton ile etkileşime girebilir
        btnRunningFinish.isUserInteractionEnabled = true
//
        swipeGestureRecognizer.delegate = self as? UIGestureRecognizerDelegate
        
        
    }

    @objc func finishTheRun(sender : UIPanGestureRecognizer) {
        
//        sağdan ve soldan sınır
        let minDiff : CGFloat = (imgRunningFinish.bounds.size.width - (btnRunningFinish.bounds.size.width) - 10) / 2
        let maxDiff : CGFloat = (imgRunningFinish.bounds.size.width - (5*btnRunningFinish.bounds.size.width/4))
        
//        sender.view => işlem buton için yapılack
        if let sliderView = sender.view {
//            swipe işlemini kontrol ediliyor / başladımı bittimi devammı ediyor vs.
            if sender.state == UIGestureRecognizer.State.began || sender.state == UIGestureRecognizer.State.changed {
//                Butonun hareket etmesini t
                let translation = sender.translation(in: self.view)
                
//                buton arada mı
                if sliderView.center.x >= (imgRunningFinish.center.x - minDiff) && sliderView.center.x <= (imgRunningFinish.center.x + maxDiff) {
                    sliderView.center = CGPoint(x: sliderView.center.x + translation.x, y: sliderView.center.y)
                } else if sliderView.center.x >= (imgRunningFinish.center.x + maxDiff){
                    sliderView.center.x = imgRunningFinish.center.x + maxDiff
                    stopToRunning()
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderView.center.x = imgRunningFinish.center.x - minDiff
                }
                sender.setTranslation(CGPoint.zero, in: self.view)
            }
//            swipe bittiyse
            else if sender.state == UIGestureRecognizer.State.ended {
                UIView.animate(withDuration: 0.2, animations: {
                    sliderView.center.x = self.imgRunningFinish.center.x - minDiff
                })
            }
        }
        
    }

    @IBAction func stopBtnClicked(_ sender: Any) {

        if timer.isValid {
            finishRunning()
        } else {
            startToRunning()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        manager?.delegate = self
//        10 metrede bir güncellemeyi yap
        manager?.distanceFilter = 10
        startToRunning()
    }
    
    func startToRunning(){
        manager?.startUpdatingLocation()
        startToTimer()
        btnStop.setImage(UIImage(named: "durdurButonu"), for:  .normal)
    }
    
    func stopToRunning(){
        manager?.stopUpdatingLocation()
        RunModel.addRunRealm(time: counter, distance: distanceOfRunning, pace: pace, locations: positions)
    }
    
    func calculatePace(second : Int, km : Double) -> String {
        pace = Int(Double(second) / km)
        return pace.counterToSecond()
    }
    
    
    func startToTimer(){
        timeLabel.text = counter.counterToSecond()
//        timer kullanımı
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    
    @objc func updateCounter(){
        counter += 1
        timeLabel.text = counter.counterToSecond()
    }
    
    
    func finishRunning(){
        firstLocation = nil
        lastLocation = nil
//        zamanlayıcı durduruldu
        timer.invalidate()
//        konum güncellemeyi sonlandırıldı.
        manager?.stopUpdatingLocation()
        btnStop.setImage(UIImage(named: "devamButonu"), for:  .normal)
    }
    

    
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            permissionCtrl()
        }
    }
//    konum güncellenince etkilenen fonksiyon
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        calculate to distance
        
        if firstLocation == nil {
            firstLocation = locations.first
        } else if let location = locations.last {
//      distance metodu bir konum ile diğer konum arasındaki mesafeyi gösteriyor.
            distanceOfRunning += lastLocation.distance(from: location)
            
            let newPosition = Location(latitude: Double(lastLocation.coordinate.latitude), longitude: Double(lastLocation.coordinate.longitude))
            
//            başa yeni konum eklendi
            positions.insert(newPosition, at: 0)
            
            let distanceSTR = String(format: "%.3f", distanceOfRunning/1000)
            distanceLabel.text = "\(distanceSTR)"
            
            if (counter > 0) && (distanceOfRunning > 0) {
                tempoLabel.text = calculatePace(second: counter, km: distanceOfRunning/1000)
            }
        }
        lastLocation = locations.last
    }
    

}
