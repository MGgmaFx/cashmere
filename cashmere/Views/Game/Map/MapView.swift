import SwiftUI
import CoreLocation

struct MapView: View {
    @Binding var toDate: Date

    var body: some View {
        
        ZStack(alignment: .top) {
            mapView()
                .edgesIgnoringSafeArea(.all)
                .statusBar(hidden: true)
            TimerView(setDate: $toDate)
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
