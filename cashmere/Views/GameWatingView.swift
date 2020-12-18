//
//  GameWatingView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/11.
//

import SwiftUI

struct GameWatingView: View {
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @Binding var roomId: String
    @Binding var players: [Player]
    @Binding var gamerule: [String : String]
    var body: some View {
        VStack {
            InvitedPlayerListView(players: $players)
            GameruleView(gamerule: $gamerule, roomId: $roomId)
        }.onAppear {
            RDDAO.getPlayers(roomId: roomId) { result in
            players = result
            }
        }
    }
}
