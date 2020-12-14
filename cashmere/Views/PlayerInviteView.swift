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
                RDDAO.updateRoomTimelimit(roomId: room.id, timelimit: time)
                RDDAO.updateRoomStatus(roomId: room.id, state: "playing")
                self.model.isPresentedGameView.toggle()
            }) {
                Text("ゲーム開始")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .fullScreenCover(isPresented: $model.isPresentedGameView) {
                GameView(time: $time, roomId: $room.id, player: $player)
            }
            .background(Color.blue)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()

            
        }
        .onAppear {
            RDDAO.getPlayerNameList(roomId: room.id) { result in
                playerList = result
            }
        }
    }
}
