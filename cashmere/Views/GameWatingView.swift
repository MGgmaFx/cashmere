//
//  GameWatingView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/11.
//

import SwiftUI

struct GameWatingView: View {
    @Binding var roomId: String
    @State var time: Int = 60
    @Binding var isGameStarted: Bool
    var RDDAO = RealtimeDatabeseDAO()
    var body: some View {
        VStack {
            Text("GameWating View")
            
            VStack {
                
            }
            .background(EmptyView()
            .fullScreenCover(isPresented: $isGameStarted) {
                GameView(time: $time)
            })
        }
    }
}
