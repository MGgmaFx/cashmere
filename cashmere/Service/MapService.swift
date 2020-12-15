//
// MapView.swift
// cashmere
//
// Created by 織音 on 2020/12/01.
//
import SwiftUI
import CoreLocation
import MapKit
import Foundation
import Firebase
struct mapView : UIViewRepresentable {
    @Binding var manager : CLLocationManager
    @Binding var alert : Bool
    @Binding var roomId: String
    @Binding var player : Player
    let map = MKMapView()
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }
    func makeUIView(context: Context) -> MKMapView {
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        // 現在地の表示（青ピン）
        map.showsUserLocation = true
        map.showsCompass = true
        map.showsScale = true
        // 測位の精度を指定(最高精度
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // 測位の精度 10メートル
        // manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        // 位置情報取得間隔を指定(2m移動したら、位置情報を通知)
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
    let RDDAO = RealtimeDatabeseDAO()
    var ref = Database.database().reference()
    static let startDate = Date().addingTimeInterval(-180071.3325)
    var parent : mapView
    init(parent1 : mapView) {
        parent = parent1
    }
    // 追跡モードが変更された(位置情報の承認)
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //    status == .denied {
        //      parent.alert.toggle()
        //      print(“denied”)
        //    }
    }
    // ユーザの場所が変更された
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        /**DBに現在地を追加*/
        var latitude = location?.coordinate.latitude
        var longitude = location?.coordinate.longitude
        var playerId = parent.player.id
        var roomId = parent.roomId
        if latitude != nil && longitude != nil {
          RDDAO.addPlayerLocation(roomId: roomId, playerId: playerId, latitude: latitude!, longitude: longitude!)
        }
        /*var playerLocations = [Double]()
        playerLocations.append(latitude)
        playerLocations.append(longitude)*/
        /**
         DBからプレイヤーの位置情報を取得
         43.057427,141.373615
         43.051846,141.385889
         43.052747,141.377778
          */
        let playerTime = 30
        let timeInterval = Date().timeIntervalSince(Coordinator.startDate)
        var elTime = Int(timeInterval)
        // 秒に変換
        elTime = elTime % 60
        if elTime > playerTime {
          // addAnnotation(latitude, longitude)
          // addAnnotation(mapView.latitude, mapView.longitude)
          addAnnotation(43.051846, 141.385889)
          addAnnotation(43.052747, 141.377778)
        }
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
        }
    }
    
    func addAnnotation(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees){
        let playerLocation = MKPointAnnotation()
        playerLocation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        self.parent.map.addAnnotation(playerLocation)
    }
}
