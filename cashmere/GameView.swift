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
            Image(systemName: "faceid")
                .resizable()
                .scaledToFit()
                .frame(width: 200.0, height: 200.0)
                .foregroundColor(.blue)
                .tabItem {
                    Image(systemName: "cube")
                    Text("アイテム")
                }
            Image(systemName: "faceid")
                .resizable()
                .scaledToFit()
                .font(.system(size: 18, weight: .ultraLight, design: .serif))
                .frame(width: 200.0, height: 200.0)
                .foregroundColor(.blue)
                .tabItem {
                    Image(systemName: "person")
                    Text("プレイヤー")
                }
        }
    }
}