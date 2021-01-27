//
//  PlayerInviteView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/12.
//

import SwiftUI

struct PlayerInviteView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var eventFlag: GameEventFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @Binding var gamerule: [String : String]
    @Binding var players: [Player]
    @Binding var room: Room
    @Binding var player: Player
    let time: Int
    var body: some View {
        VStack {
            
            InvitedPlayerListView(players: $players)
            
            QRCodeView(room: $room)
                .padding()
            
            if players.count > 1 {
                Button(action: {
                    DispatchQueue.main.async {
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        RDDAO.updateRoomStatus(roomId: room.id, state: "playing")
                        RDDAO.updatePlayerRole(roomId: room.id, playerId: player.id, role: "killer")
                        RDDAO.updateGameStartTime(roomId: room.id, startTime: dateFormatter.string(from: date))
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double((Int(gamerule["escapeTime"] ?? "99")! * 60))) {
                            eventFlag.isEscaping = false
                            eventFlag.isGameStarted = true
                        }
                        DispatchQueue.main.async {
                            model.playerInvitePushed = false
                            DispatchQueue.main.async {
                                eventFlag.isEscaping = true
                            }
                        }
                    }
                    
                }) {
                    Text("ゲーム開始")
                        .frame(width: 240, height: 60, alignment: .center)
                }
                .buttonStyle(CustomButtomStyle(color: Color.blue))
            } else {
                Button(action: {
                    
                }) {
                    Text("ゲーム開始")
                }
                .buttonStyle(CustomButtomStyle(color: Color.gray))
                .disabled(true)
            }

            
        }
    }
}