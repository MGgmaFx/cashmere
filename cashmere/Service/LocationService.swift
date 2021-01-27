//
//  LocationService.swift
//  cashmere
//
//  Created by 織音 on 2021/01/22.
//

import SwiftUI
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
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .authorizedAlways:
            print("常に許可")
        case .authorizedWhenInUse:
            print("使用時のみ許可")
        case .denied:
            print("承認拒否")
        case .notDetermined:
            print("未設定")
        case .restricted:
            print("機能制限")
        @unknown default:
            print("何も一致しなかったよ")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let roomLatitude = String(location?.coordinate.latitude ?? 200)
        let roomLongitude = String(location?.coordinate.longitude ?? 200)
        roomLocation = ["roomLatitude": roomLatitude, "roomLongitude": roomLongitude]
        print("roomLocation: \(roomLocation)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }
}
