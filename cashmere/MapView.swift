import SwiftUI
import CoreLocation

struct MapView: View {
    @State var manager = CLLocationManager()
    @State var alert = false
    var body: some View {
        // 以下の行を追加
        // ContentViewに地図を表示
        mapView(manager: $manager, alert: $alert).alert(isPresented: $alert) {
          Alert(title: Text("Please Enable Location Access In Setting Panel!!!"))
        }
    }
}
