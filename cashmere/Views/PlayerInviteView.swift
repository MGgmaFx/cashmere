//
//  PlayerInviteView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/12.
//

import SwiftUI

struct PlayerInviteView: View {
    @EnvironmentObject var model: Model
    @Binding var room: Room
    @Binding var time: Int
    @Binding var player: Player
    @State var playerList: [String] = []
    var RDDAO = RealtimeDatabeseDAO()
    var body: some View {
        VStack {
            
            InvitedPlayerListView(playerList: $playerList)
            
            QRCodeView(room: $room)
                .padding()
            
            Button(action: {
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "HH:mm:ss"
                RDDAO.updateRoomStatus(roomId: room.id, state: "playing")
                RDDAO.updateGameStartTime(roomId: room.id, startTime: dateFormatter.string(from: date))
                self.model.isPresentedGameView.toggle()
            }) {
                Text("ゲーム開始")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .fullScreenCover(isPresented: $model.isPresentedGameView) {
                GameView(time: $time, roomId: $room.id, player: $player)
            }
            .buttonStyle(CustomButtomStyle(color: Color.blue))

            
        }
        .onAppear {
            RDDAO.getPlayerNameList(roomId: room.id) { result in
                playerList = result
            }
        }
    }
}
