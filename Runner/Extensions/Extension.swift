//
//  Extension.swift
//  Runner
//
//  Created by Vahit Emre TELLİER on 23.01.2022.
//

import Foundation

extension Int {
    
//    sayacı saniye zaman cinsine cevrilip Integer sınıfına extension edildi.
    func counterToSecond() -> String{
        
        let hour = self / 3600
        let minute = (self % 3600) / 60
        let second = (self % 3600) % 60
        
        if second <= 0 {
            return "00:00:00"
        } else {
            if hour == 0 {
                return String(format: "%02d:%02d", minute, second)
            } else {
                return String(format: "%02d:%02d:%02d", hour,minute,second)
            }
        }
    }
    
}

extension NSDate {
    func getDate() -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self as Date)
        let mounth = calendar.component(.month, from: self as Date)
        let year = calendar.component(.year, from: self as Date)
        
        return "\(day).\(mounth).\(year)"
    }
}
