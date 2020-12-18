//
//  GameView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameFlag: GameEventFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @Binding var players: [Player]
    @Binding var roomId: String
    @Binding var player: Player
    let time: Int
    var body: some View {
        TabView {
            MapView(roomId: $roomId, player: $player, players: $players, time: time)
                .tabItem {
                    Image(systemName: "map")
                    Text("マップ")
                }
            ItemView()
                .tabItem {
                    Image(systemName: "case.fill")
                    Text("アイテム")
                }
            PlayerView(players: $players)
                .tabItem {
                    Image(systemName: "figure.walk")
                    Text("プレイヤー")
                }
        }
        .alert(isPresented: $gameFlag.isGameOver) {
            Alert(title: Text("ゲーム終了"))
        }
    }
}
