//
//  LocationService.swift
//  cashmere
//
//  Created by 織音 on 2021/01/22.
//

import SwiftUI
import CoreLocation

class requestLocation: NSObject,CLLocationManagerDelegate {
    
    let manager = CLLocationManager()
    // 非同期処理用のクロージャ
    typealias compLocation = (_ location:[String:String]) -> Void
    
    public var roomLocation:[String:String] = [:]
    
    override init(){
        super.init()
        manager.requestWhenInUseAuthorization()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // 位置情報を取得する処理(取得できるまで0.5秒再帰)
    func getLocation(comp:@escaping compLocation) {
        if roomLocation.isEmpty {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                // 0.5秒待機
                self.getLocation(comp: comp)
            }
        } else {
            // 位置情報を取得
            comp(roomLocation)
        }
    }
    
    deinit {
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status{
        case .authorizedAlways:
            print("常に許可")
            manager.startUpdatingLocation()
        case .authorizedWhenInUse:
            print("使用時のみ許可")
            manager.startUpdatingLocation()
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
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("位置情報の取得に失敗しました")
    }
}
