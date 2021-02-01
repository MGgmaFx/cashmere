//
//  GameView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var gameEventFlag: GameEventFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @Binding var players: [Player]
    @Binding var roomId: String
    @Binding var player: Player
    @Binding var gamerule: [String : String]
    let time: Int
    var body: some View {
        VStack {
            TabView {
                MapView(roomId: $roomId, player: $player, players: $players, gamerule: $gamerule, time: time)
                    .tabItem {
                        Image(systemName: "map")
                        Text("マップ")
                    }
                ItemView(gamerule: $gamerule, roomId: $roomId, player: $player)
                    .tabItem {
                        Image(systemName: "case.fill")
                        Text("アイテム")
                    }
                PlayerView(players: $players)
                    .tabItem {
                        Image(systemName: "figure.walk")
                        Text("プレイヤー")
                    }
            }.fullScreenCover(isPresented: $gameEventFlag.isGameOver, content: {
                ResultView(player: $player, players: $players)
            })
            
            VStack {
            }
            .background(EmptyView().sheet(isPresented: $gameEventFlag.isCaptured) {
                GameOverView()
            })
        }
    }
}
