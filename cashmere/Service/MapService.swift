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
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @Binding var manager: CLLocationManager
    @Binding var alert: Bool
    @Binding var roomId: String
    @Binding var player: Player
    @Binding var players: [Player]
    @Binding var gamerule: [String : String]
    let map = MKMapView()

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent1: self)
    }
    
    func makeUIView(context: Context) -> MKMapView {
        manager.requestWhenInUseAuthorization()
        manager.delegate = context.coordinator
        map.showsUserLocation = true
        map.showsCompass = true
        // map.showsScale = true
        // 測位の精度を指定(最高精度
        manager.desiredAccuracy = kCLLocationAccuracyBest
        // 位置情報取得間隔を指定(2m移動したら、位置情報を通知)
        manager.distanceFilter = 2
        
        // 下のlocationManagerを呼び出している
        manager.startUpdatingLocation()
        
        /**
        逃走エリア　作成中
        let latitude = player.latitude
        let longitude = player.longitude
        /*let center = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        let region = CLCircularRegion(center: center, radius: 1000.0, identifier: "逃走エリア")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        manager.startMonitoring(for: region)*/
        let center = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let myCircle: MKCircle = MKCircle(center: center, radius: CLLocationDistance(1000))
        map.addOverlay(myCircle)
         */
       
        return map
    }
    // 更新されたときの処理
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
}

class Coordinator : NSObject,CLLocationManagerDelegate{
    var parent : mapView
    var timer: Timer?
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
        /**
         位置情報送信タイミングの設定
         */
        let timeInterval = Double(parent.gamerule["survivorPositionTransmissionInterval"] ?? "1")! * 60
        self.timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.default)
        
        /**
         現在地書き込み処理
         */
        let location = locations.last
        let latitude = location?.coordinate.latitude
        let longitude = location?.coordinate.longitude
        let playerId = parent.player.id
        let roomId = parent.roomId
        if latitude != nil && longitude != nil && parent.player.captureState != "captured" {
            parent.RDDAO.addPlayerLocation(roomId: roomId, playerId: playerId, latitude: latitude!, longitude: longitude!)
        }
        
        /**
         確保系処理
         */
        let killerCaptureRange = Int(parent.gamerule["killerCaptureRange"] ?? "10")
        for player in parent.players {
            if parent.player.id != player.id && player.captureState != "captured" {
                let targetLatitude = player.latitude ?? 0.0
                let targetLongitude = player.longitude ?? 0.0
                let coordinate1 = CLLocation(latitude: latitude!, longitude: longitude!)
                let coordinate2 = CLLocation(latitude: targetLatitude, longitude: targetLongitude)
                let distanceInMeters = Int(coordinate1.distance(from: coordinate2))
                print("生存者との距離 " + String(distanceInMeters))
                if distanceInMeters <= killerCaptureRange ?? 10 {
                    print("♡♡♡捕まえちゃったわよ♡♡♡")
                    print("♡♡♡" + player.id + "♡♡♡")
                    parent.RDDAO.addCaptureFlag(roomId: parent.roomId, playerId: player.id)
                }
            }
        }
       
        let georeader = CLGeocoder()
        georeader.reverseGeocodeLocation(location!) {
          (places, err) in
          if err != nil{
            print((err?.localizedDescription)!)
            return
          }
        }
    }
    
    @objc func timerUpdate() {
        print("♡♡♡出力しちゃうわよ♡♡♡")
        addAnnotations(self.parent.players)
    }
    
    func addAnnotations(_ players: [Player]) {
        self.parent.map.removeAnnotations(self.parent.map.annotations)
        let pin = MKPointAnnotation()
        for player in players {
            if player.latitude != nil && player.longitude != nil && player.captureState != "captured"{
                let latitude = player.latitude!
                let longitude = player.longitude!
                pin.subtitle = player.id
                pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.parent.map.addAnnotation(pin)
            }
        }
         
    }
}
