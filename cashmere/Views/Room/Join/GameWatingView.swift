//
//  GameWatingView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/11.
//

import SwiftUI

struct GameWatingView: View {
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @EnvironmentObject var gameFlag: GameEventFlag
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
            if gameFlag.isGameStarted {
                checkAllCaught(plyers: players){ (isAllCaught) in
                    if isAllCaught {
                        gameFlag.isGameOver = isAllCaught
                    }
                }
            }
            }
        }
    }
    private func checkAllCaught(plyers: [Player], completionHandler: @escaping (Bool) -> Void) {
        var isAllCaught = true
        for player in players {
            if player.captureState != "captured" && player.role == "survivor" {
                isAllCaught = false
            }
        }
        completionHandler(isAllCaught)
    }
}
