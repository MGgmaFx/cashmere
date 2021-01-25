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

extension UIColor {
    var color: Color {
        return Color(self)
    }
}


struct mapView : UIViewRepresentable {
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @Binding var manager: CLLocationManager
    @Binding var alert: Bool
    @Binding var roomId: String
    @Binding var player: Player
    @Binding var players: [Player]
    @Binding var gamerule: [String : String]
    typealias UIViewType = MKMapView
    let map = MKMapView()
    // マップのデリゲートを定義
    let mapViewDelegate = MapViewDelegate()

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
        // 同期の終了
        // manager.stopUpdatingLocation()
        return map
    }
    
    // 更新されたときの処理
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 逃走エリア　作成中
        // let center = CLLocationCoordinate2DMake(parent.player.latitude ?? 35.362222, parent.player.longitude ?? 138.731388)
        // 表示しているマップとデリゲートを紐付け
        uiView.delegate = mapViewDelegate
        // 中心点を定義(latitudeは緯度、latitudeは経度)
        let coordinate = CLLocationCoordinate2D(latitude: 43.056063, longitude: 141.375932)
        // 領域を定義
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        // マップの表示領域を定義
        let region = MKCoordinateRegion(center: coordinate, span: span)
        // マップに設定
        uiView.setRegion(region, animated: true)
        
        // 円の定義(centerは中心点、radiusは半径)
        let circle = MKCircle(center: coordinate, radius: 5000)
        // 円の追加
        uiView.addOverlay(circle)
    }
}

class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        //円のborderの色
        circle.strokeColor = UIColor.red
        //円全体の色。今回は赤色
        circle.fillColor = UIColor(Color(red: 0.8, green: 0.5, blue: 0.5, opacity: 0.1))
        //円のボーダーの太さ。
        circle.lineWidth = 1.0
        return circle
    }
}

class Coordinator : NSObject,CLLocationManagerDelegate,MKMapViewDelegate {
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
        // let timeInterval = Double(parent.gamerule["survivorPositionTransmissionInterval"] ?? "1")! * 60
        let timeInterval = Double(10)
        self.timer = Timer(timeInterval: timeInterval, target: self, selector: #selector(timerUpdate), userInfo: nil, repeats: true)
        RunLoop.main.add(self.timer!, forMode: RunLoop.Mode.default)
        //　タイマーの終了
        // timer?.invalidate()
        
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
            // && parent.player.id != player.id
            if player.latitude != nil && player.longitude != nil && player.captureState != "captured" {
                let latitude = player.latitude!
                let longitude = player.longitude!
                pin.subtitle = player.id
                pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.parent.map.addAnnotation(pin)
            }
        }
    }
}
