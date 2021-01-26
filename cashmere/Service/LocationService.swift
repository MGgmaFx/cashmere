//
//  LocationService.swift
//  cashmere
//
//  Created by 織音 on 2021/01/22.
//

import SwiftUI
import UIKit
import CoreLocation

class requestLocation: NSObject {
    
    let manager = CLLocationManager()
    
    public var roomLocation:[String:String] = [:]
    
    override init(){
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
}

extension requestLocation: CLLocationManagerDelegate {
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let roomLatitude = String(location?.coordinate.latitude ?? 0)
        let roomLongitude = String(location?.coordinate.longitude ?? 0)
        roomLocation = ["roomLatitude": roomLatitude, "roomLongitude": roomLongitude]
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }
}
