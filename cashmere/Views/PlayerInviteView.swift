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
    @State var playerList: [String] = []
    var RDDAO = RealtimeDatabeseDAO()
    var body: some View {
        VStack {
            
            Text("プレイヤー一覧")
                .foregroundColor(.primary)
                .padding()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(playerList, id: \.self) { value in
                        VStack {
                            Image(systemName: "figure.walk")
                                .resizable()
                                .frame(width: 40, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.blue)
                            Text(value)
                                .foregroundColor(.primary)
                        }
                        .padding()
                    }
                }
            }
            
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
                GameView(time: $time)
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
