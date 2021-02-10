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
    @EnvironmentObject var room: Room
    var body: some View {
        VStack {
            
            InvitedPlayerListView()
            
            QRCodeView()
                .padding()
            
            if room.players.count > 1 {
                Button(action: {
                    DispatchQueue.main.async {
                        let date = Date()
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "HH:mm:ss"
                        RDDAO.updateRoomStatus(roomId: room.id, state: .playing)
                        RDDAO.updatePlayerRole(roomId: room.id, playerId: room.me.id, role: .killer)
                        RDDAO.updateGameStartTime(roomId: room.id, startTime: dateFormatter.string(from: date))
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(room.rule.escapeTime) * 60) {
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
                .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "0BBB18"))))
            } else {
                Button( action: {
                    
                }) {
                    Text("ゲーム開始")
                        .frame(width: 240, height: 60, alignment: .center)
                }
                .buttonStyle(CustomButtomStyle(color: Color.gray))
                .disabled(true)
            }
        

            
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
        ).background(Color(UIColor(hex: "212121"))).edgesIgnoringSafeArea(.all)
    }
}
