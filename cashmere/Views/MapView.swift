import SwiftUI
import CoreLocation

struct MapView: View {
    @State var manager = CLLocationManager()
    @State var alert = false
    @Binding var roomId: String
    @Binding var player: Player
    @Binding var players: [Player]
    let time: Int
    var body: some View {
        let toDate = Calendar.current.date(byAdding:.minute, value: time, to:Date())
        // ContentViewに地図を表示
        ZStack(alignment: .top) {
            mapView(manager: $manager, alert: $alert, roomId: $roomId, player: $player, players: $players).alert(isPresented: $alert) {
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
