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
    @Binding var manager: CLLocationManager
    @Binding var alert: Bool
    @Binding var roomId: String
    @Binding var player: Player
    
    
    let map = MKMapView()
    let RDDAO = RealtimeDatabeseDAO()
    var ref = Database.database().reference()
    
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
        // 位置情報取得間隔を指定(2m移動したら、位置情報を通知)
        manager.distanceFilter = 2
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
        //    status == .denied {
        //      parent.alert.toggle()
        //      print(“denied”)
        //    }
    }
    // ユーザの場所が変更された
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = locations.last
        /**DBに現在地を追加*/
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        let playerId = parent.player.id
        let roomId = parent.roomId
        if latitude != nil && longitude != nil {
            parent.RDDAO.addPlayerLocation(roomId: roomId, playerId: playerId, latitude: latitude!, longitude: longitude!)
        }
        
        /**
         DBからプレイヤーの位置情報を取得
         43.057427,141.373615
         43.051846,141.385889
         43.052747,141.377778
         
         42.958746,141.312503
         42.982611,141.334991
         43.020901,141.348724
         43.078731,141.344261
         */
        
        var players: [Player] = []
        
        parent.RDDAO.getPlayers(roomId: parent.roomId) { (result) in
            print(result)
            players = result
            self.addAnnotations(players)
        }
        
        
        // parent.RDDAO.getPlayerLocation(roomId: roomId, playerId: playerId)
        
        
        let georeader = CLGeocoder()
        georeader.reverseGeocodeLocation(location!) {
          (places, err) in
          if err != nil{
            print((err?.localizedDescription)!)
            return
          }
        }
    }
    
    func addAnnotations(_ players: [Player]){
        let pin = MKPointAnnotation()
        for player in players {
            print(player)
            if player.latitude != nil && player.longitude != nil {
                var latitude = player.latitude!
                var longitude = player.longitude!
                pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.parent.map.addAnnotation(pin)
            }
        }
        
    }
}
