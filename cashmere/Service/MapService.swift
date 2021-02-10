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
    @EnvironmentObject var itemFlag: ItemFlag
    @EnvironmentObject var gameFlag: GameEventFlag
    @EnvironmentObject var room: Room
    @State var manager: CLLocationManager = CLLocationManager()
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
        
        let roomLatitude = Double(room.point?.roomLatitude ?? "0")
        let roomLongitude = Double(room.point?.roomLongitude ?? "0")
        // 中心点を定義(latitudeは緯度、latitudeは経度)
        let coordinate = CLLocationCoordinate2D(latitude: roomLatitude!, longitude: roomLongitude!)
        // 領域を定義
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        // マップの表示領域を定義
        let region = MKCoordinateRegion(center: coordinate, span: span)
        // マップに設定
        map.setRegion(region, animated: true)
        // 円の半径を設定
        let radius = Double(room.rule.escapeRange)
        // 円の定義(centerは中心点、radiusは半径)
        let circle = MKCircle(center: coordinate, radius: radius)
        // 円の追加
        map.addOverlay(circle)
        // 下のlocationManagerを呼び出している
        manager.startUpdatingLocation()
        return map
    }
    
    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }
    
    
    // 更新されたときの処理
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 表示しているマップとデリゲートを紐付け
        uiView.delegate = mapViewDelegate
        
        
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
    init(parent1 : mapView) {
        parent = parent1
    }
    
    // 追跡モードが変更された(位置情報の承認)
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
        /**
         位置情報送信間隔
         */
        DispatchQueue.global(qos: .default).async {
            self.countTimer()
        }
    }
    
    // ユーザの場所が変更された
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        if parent.gameFlag.isGameOver {
            print("げーむの終了")
            parent.stopUpdatingLocation()
        }
        /**
         現在地書き込み処理
         */
        let location = locations.last
        let latitude = location?.coordinate.latitude ?? 0.0
        let longitude = location?.coordinate.longitude ?? 0.0
        let playerId = parent.room.me.id
        let roomId = parent.room.id
        if parent.room.me.captureState != .captured {
            parent.RDDAO.addPlayerLocation(roomId: roomId, playerId: playerId, latitude: latitude, longitude: longitude)
        }
        
        /**
         確保系処理
         */
        let killerCaptureRange = parent.room.rule.killerCaptureRange
        for player in parent.room.players {
            if parent.room.me.id != player.id && player.captureState == .escaping {
                let targetLatitude = player.latitude ?? 0.0
                let targetLongitude = player.longitude ?? 0.0
                let myLocation = CLLocation(latitude: latitude, longitude: longitude)
                let yourLocation = CLLocation(latitude: targetLatitude, longitude: targetLongitude)
                let distanceInMeters = Int(myLocation.distance(from: yourLocation))
                print("生存者との距離 " + String(distanceInMeters))
                if distanceInMeters <= killerCaptureRange {
                    print("生存者の確保")
                    parent.RDDAO.addCaptureFlag(roomId: parent.room.id, playerId: player.id)
                }
            }
        }
        
        /**
         サーチライト(アイテム)メソッドの呼び出し
         */
        if parent.itemFlag.useSearchlight {
            print("searchLightの呼び出し")
            searchLight(self.parent.room.players)
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
    
    public func countTimer() {
        let time = parent.room.rule.survivorPositionTransmissionInterval * 60
        while !(parent.gameFlag.isGameOver) {
            print("countTimer を呼び出し")
            sleep(UInt32(time))
            if parent.room.me.role == .killer {
                DispatchQueue.main.async { [self] in
                    print("addAnnotations を呼び出し")
                    addAnnotations(players: parent.room.players)
                }
            }
        }
    }
    
    func addAnnotations(players: [Player]) {
        parent.map.removeAnnotations(parent.map.annotations)
        let pin = MKPointAnnotation()
        for player in players {
            if parent.room.me.id != player.id && player.role == .survivor && player.captureState == .escaping {
                let latitude = player.latitude ?? 0.0
                let longitude = player.longitude ?? 0.0
                pin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.parent.map.addAnnotation(pin)
            }
        }
    }
    
    
    /**
     サーチライト：鬼の位置情報を表示(1分間)
     ピンの削除処理を追加予定
     */
    func searchLight(_ players: [Player]) {
        let killerPin = MKPointAnnotation()
        for player in players {
            if parent.room.me.id != player.id && player.role == .killer {
                print("鬼を表示するよ")
                let latitude = player.latitude ?? 0.0
                let longitude = player.longitude ?? 0.0
                killerPin.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                self.parent.map.addAnnotation(killerPin)
                DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
                    self.parent.map.removeAnnotation(killerPin)
                }
            }
        }
        // self.parent.map.removeAnnotations(self.parent.map.annotations)
    }
}

