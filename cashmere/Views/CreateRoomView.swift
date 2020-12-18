//
//  CreateRoom.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI
import Firebase

struct CreateRoomView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @State var room = Room(name: "鬼ごっこルーム")
    @State var players: [Player] = []
    @State var gamerule: [String : String] = [:]
    @State var hour = 0
    @State var minute = 29
    @State var killerCaptureRange = 9
    @State var survivorPositionTransmissionInterval = 2
    @State var escapeTime = 2
    @State var time = 59
    @Binding var player: Player
    var body: some View {
        VStack {
            Spacer()
            Text("CreateRoom View").font(.title)
            Spacer()
            
            GameruleSettingsView(room: $room, hour: $hour, minute: $minute, killerCaptureRange: $killerCaptureRange, survivorPositionTransmissionInterval: $survivorPositionTransmissionInterval, escapeTime: $escapeTime)
            
            Spacer()
            
            Button(action: {
                time = hour * 60 + minute
                RDDAO.updateGamerule(roomId: room.id, timelimit: time, killerCaptureRange: killerCaptureRange, survivorPositionTransmissionInterval: survivorPositionTransmissionInterval, escapeTime: escapeTime)
                model.playerInvitePushed = true
                RDDAO.getGameRule(roomId: room.id) { (result) in
                    gamerule = result
                }
            }) {
                Text("プレイヤーを招待する")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .sheet(isPresented: $model.playerInvitePushed) {
                PlayerInviteView(gamerule: $gamerule, players: $players, room: $room, player: $player, time: time)
            }
            .buttonStyle(CustomButtomStyle(color: Color.green))
            
            Button(action: {
                model.createRoomViewPushed = false
            }) {
                Text("もどる")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .buttonStyle(CustomButtomStyle(color: Color.gray))
            
        }
        .onAppear{
            roomInit(room: room)
            RDDAO.getGameRule(roomId: room.id) { (result) in
                gamerule = result
            }
            RDDAO.getPlayers(roomId: room.id) { (result) in
                players = result
            }
        }
        .onDisappear{
            roomDel(room: room)
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    }
    private func roomInit(room: Room) {
        RDDAO.updateRoomStatus(roomId: room.id, state: "wating")
        RDDAO.addPlayer(roomId: room.id, playerId: player.id, playerName: player.name)
    }
    
    private func roomDel(room: Room) {
        RDDAO.deleteRoom(roomId: room.id)
    }
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
