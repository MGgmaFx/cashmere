import SwiftUI
import CoreLocation

struct MapView: View {
    var toDate = Calendar.current.date(byAdding:.hour,value:56,to:Date())
    @State var manager = CLLocationManager()
    @State var alert = false
    var body: some View {
        // ContentViewに地図を表示
        ZStack(alignment: .top) {
            mapView(manager: $manager, alert: $alert).alert(isPresented: $alert) {
              Alert(title: Text("Please Enable Location Access In Setting Panel!!!"))
            }
            TimerView(setDate: toDate!)
                .frame(width: 320, height: 60)
                .background(Color.gray)
                .foregroundColor(Color.white)
                .cornerRadius(20)
                .padding(.top, 40)
                .opacity(0.8)
                
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
