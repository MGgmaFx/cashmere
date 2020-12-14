//
//  GameView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct GameView: View {
    @Binding var time: Int
    @Binding var roomId: String
    @Binding var player: Player
    @State var isGameOver = false
    var body: some View {
        TabView {
            MapView(time: $time, isGameOver: $isGameOver, roomId: $roomId, player: $player)
                .tabItem {
                    Image(systemName: "map")
                    Text("マップ")
                }
            ItemView()
                .tabItem {
                    Image(systemName: "case.fill")
                    Text("アイテム")
                }
            PlayerView()
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("プレイヤー")
                }
        }
        .alert(isPresented: $isGameOver) {
            Alert(title: Text("ゲーム終了"))
        }
    }
}
