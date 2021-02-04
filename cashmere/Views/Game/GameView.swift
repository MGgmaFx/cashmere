//
//  GameView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI
import UIKit

struct GameView: View {
    @EnvironmentObject var gameEventFlag: GameEventFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @State var pinColor: Color = Color.blue
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
                if player.role == "survivor" {
                    ItemView(gamerule: $gamerule, roomId: $roomId, player: $player)
                        .tabItem {
                            Image(systemName: "case.fill")
                            Text("アイテム")
                        }
                }
                PlayerView(players: $players)
                    .tabItem {
                        Image(systemName: "figure.walk")
                        Text("プレイヤー")
                    }
            }
            .accentColor(pinColor) // 選択したアイテム色を指定
            .fullScreenCover(isPresented: $gameEventFlag.isGameOver, content: {
                ResultView(player: $player, players: $players)
            })
            
            VStack {
            }
            .alert(isPresented: $gameEventFlag.isCaptured) {
                Alert(title: Text("通知"),
                      message: Text("鬼に確保されました！"),
                      dismissButton: .default(Text("了解")))
            }
        }.onAppear {
            if player.role == "survivor" {
                pinColor = Color.blue
            } else {
                pinColor = Color.red
            }
        }
    }
}
