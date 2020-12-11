//
//  MapView.swift
//  cashmere
//
//  Created by 織音 on 2020/12/01.
//

import SwiftUI
import CoreLocation
import MapKit
import Foundation

struct mapView : UIViewRepresentable {
    
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    // static var latitude = 43.056046
    // static var longitude = 141.378373

    let map = MKMapView()
    
   
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }
    
    
    func makeUIView(context: Context) -> MKMapView {
        let center = CLLocationCoordinate2D(latitude: 43.056046, longitude: 141.378373)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))

        map.region = region
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        // 現在地の表示（青ピン）
        map.showsUserLocation = true
        map.showsCompass = true
        map.showsScale = true
        // 測位の精度を指定(最高精度
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // 位置情報取得間隔を指定(5m移動したら、位置情報を通知)
        manager.distanceFilter = 2
        
       
        /* 方向ボタンの作成
        let button = MKUserTrackingButton()
        map.addSubview(button)*/
        
        // 下のlocationManagerを呼び出している
        manager.startUpdatingLocation()
        return map
    }
    
    
    // 更新されたときの処理
    func updateUIView(_ uiView: MKMapView, context: Context) {

    }
    

    
}

class Coordinator : NSObject,CLLocationManagerDelegate{
    static let startDate = Date().addingTimeInterval(-180071.3325)
    
    var parent : mapView
    init(parent1 : mapView) {

        parent = parent1
    }
    // 追跡モードが変更された(位置情報の承認)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        status == .denied{
            parent.alert.toggle()
            print("denied")
        }
        
    }
    
    // ユーザの場所が変更された
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        
        let location = locations.last
        
        // let latitude = 43.056046
        // let longitude = 141.378373
        
        /*var playerLocations = [Double]()
        playerLocations.append(latitude)
        playerLocations.append(longitude)*/

        /**
         DBにアクセス プレイヤーの位置情報を取得
         */
        // 43.057427,141.373615
        // 43.051846,141.385889
        // 43.052747,141.377778
        
        
        let playerTime = 30
        let timeInterval = Date().timeIntervalSince(Coordinator.startDate)
        var elTime = Int(timeInterval)
        // 秒に変換
        elTime = elTime % 60
        
        if elTime > playerTime {
            addAnnotation(43.051846, 141.385889)
            addAnnotation(43.052747, 141.377778)
        }
        
        
        
        // addAnnotation(latitude, longitude)
        // addAnnotation(mapView.latitude, mapView.longitude)
        
        
        /* 方向ボタン
        let button = MKUserTrackingButton()
        button.layer.backgroundColor = UIColor(white: 1, alpha: 0.7).cgColor
        button.frame = CGRect(x:40, y:730, width:40, height:40)
        self.parent.map.addSubview(button)*/
        
        
        let georeader = CLGeocoder()
        georeader.reverseGeocodeLocation(location!) {
            (places, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            // self.parent.map.removeAnnotations(self.parent.map.annotations)
            // span = 描画する領域
            // let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            // 位置情報と描画する領域
            // let region = MKCoordinateRegion(center: location!.coordinate, span: span)
            
            // let centerCoordinate = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
            // self.parent.map.setCenter(centerCoordinate, animated: true)
            
            // self.parent.map.region = region
            
            // 方向設定
            // self.parent.map.setUserTrackingMode(MKUserTrackingMode.followWithHeading, animated: false)

        }
    }
    
    
    func addAnnotation(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees){
        let playerLocation = MKPointAnnotation()
        
        playerLocation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.parent.map.addAnnotation(playerLocation)
        
    }
    
    @IBAction func trackingButton(_ sender: UIButton){
        print("押したわね")
    }
}
