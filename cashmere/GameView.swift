//
//  GameView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct GameView: View {
    var body: some View {
        TabView {
            MapView()
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
    }
}
