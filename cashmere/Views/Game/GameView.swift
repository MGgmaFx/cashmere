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
        }
    }
}
