//
//  PlayerView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct PlayerView: View {
    @Binding var players: [Player]
    var body: some View {
        ZStack {
            Color(UIColor(hex: "212121")).edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    ForEach(players, id: \.id) { player in
                        PlayerListRow(playerName: player.name, captureState: player.captureState ?? "取得中...", role: player.role ?? "取得中...")
                            .listRowBackground(Color(UIColor(hex: "212121")))
                    }
                }
                .onAppear {
                    // Listの背景色を変えるための処理
                    UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                    UITableView.appearance().backgroundColor = UIColor.clear
                    UITableView.appearance().separatorStyle = .singleLine
                    UITableView.appearance().separatorColor = UIColor.white.withAlphaComponent(0.6)
                }
            }
        }
    }
}
