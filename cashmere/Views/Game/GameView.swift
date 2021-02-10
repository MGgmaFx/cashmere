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
    @EnvironmentObject var room: Room
    @State var pinColor: Color = Color.blue
    @State var toDate: Date = Date()

    var body: some View {
        VStack {
            TabView {
                MapView(toDate: $toDate)
                    .tabItem {
                        Image(systemName: "map")
                        Text("マップ")
                    }
                if room.me.role == .survivor {
                    ItemView()
                        .tabItem {
                            Image(systemName: "case.fill")
                            Text("アイテム")
                        }
                }
                PlayerView(players: $room.players)
                    .tabItem {
                        Image(systemName: "figure.walk")
                        Text("プレイヤー")
                    }
            }
            .accentColor(pinColor) // 選択したアイテム色を指定
            .fullScreenCover(isPresented: $gameEventFlag.isGameOver, content: {
                ResultView()
            })
            
            VStack {
            }
            .alert(isPresented: $gameEventFlag.isCaptured) {
                Alert(title: Text("通知"),
                      message: Text("鬼に確保されました！"),
                      dismissButton: .default(Text("了解")))
            }
        }.onAppear {
            toDate = Calendar.current.date(byAdding:.minute, value: room.rule.time, to:Date())!
            if room.me.role == .survivor {
                pinColor = Color.blue
            } else {
                pinColor = Color.red
            }
            // ゲーム判定処理(プレイヤーの位置情報が書き換わるたびにFireabaseからフックされる)
            RDDAO.getPlayers(room: room) { (players) in
                room.players = players
                for player in players {
                    if room.me.id == player.id {
                        room.me.latitude = player.latitude
                        room.me.longitude = player.longitude
                        room.me.onlineStatus = player.onlineStatus
                        room.me.captureState = player.captureState
                        if room.me.captureState == .captured {
                            gameEventFlag.isCaptured = true
                        }
                    }
                }
                if gameEventFlag.isGameStarted {
                    checkAllCaught(plyers: room.players){ (isAllCaught) in
                        if isAllCaught {
                            gameEventFlag.isGameOver = isAllCaught
                        }
                    }
                }
            }
        }
    }
    
    private func checkAllCaught(plyers: [Player], completionHandler: @escaping (Bool) -> Void) {
        var isAllCaught = true
        for player in room.players {
            if player.captureState != .captured && player.role == .survivor {
                isAllCaught = false
            }
        }
        completionHandler(isAllCaught)
    }
}
