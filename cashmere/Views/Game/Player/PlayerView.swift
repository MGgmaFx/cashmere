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
        List {
            ForEach(players, id: \.id) { player in
                PlayerListRow(playerName: player.name, onlineStatus: player.onlineStatus ?? "取得中...", role: player.role ?? "取得中...")
            }
        }
    }
}
