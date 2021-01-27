//
//  CircleMapView.swift
//  cashmere
//
//  Created by 織音 on 2021/01/22.
//

import SwiftUI
import MapKit

struct CircleMapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    // マップのデリゲートを定義
    let mapViewDelegate = MapViewDelegate()
    
    func makeUIView(context: UIViewRepresentableContext<CircleMapView>) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: UIViewRepresentableContext<CircleMapView>) {
        // 表示しているマップとデリゲートを紐付け
        uiView.delegate = mapViewDelegate
        // 中心点を定義(latitudeは緯度、latitudeは経度)
        let coordinate = CLLocationCoordinate2D(latitude: 37.3351, longitude: -122.0088)
        // 領域を定義
        let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
        // マップの表示領域を定義
        let region = MKCoordinateRegion(center: coordinate, span: span)
        // マップに設定
        uiView.setRegion(region, animated: true)
        
        // 円の定義(centerは中心点、radiusは半径)
        let circle = MKCircle(center: coordinate, radius: 800)
        // 円の追加
        uiView.addOverlay(circle)
    }
}

// 円のデザイン設定
class MapViewDelegate: NSObject, MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let circle : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
        //円のborderの色
        circle.strokeColor = UIColor.red
        //円全体の色。今回は赤色
        circle.fillColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 0.5)
        //円のボーダーの太さ。
        circle.lineWidth = 1.0
        return circle
    }
}

