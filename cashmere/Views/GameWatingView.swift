//
//  GameWatingView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/11.
//

import SwiftUI

struct GameWatingView: View {
    @Binding var roomId: String
    @State var playerList: [String] = []
    var RDDAO = RealtimeDatabeseDAO()
    var body: some View {
            InvitedPlayerListView(playerList: $playerList)
                .onAppear {
                    RDDAO.getPlayerNameList(roomId: roomId) { result in
                    playerList = result
            }
        }
    }
}
