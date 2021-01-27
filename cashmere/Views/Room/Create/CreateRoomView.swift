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
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var gameFlag: GameEventFlag
    @State var room = Room(name: "鬼ごっこルーム")
    @State var players: [Player] = []
    @State var gamerule: [String : String] = [:]
    @State var hour = 0
    @State var minute = 29
    @State var killerCaptureRange = 9
    @State var survivorPositionTransmissionInterval = 2
    @State var escapeTime = 2
    @State var time = 59
    @State var escapeRange = 39
    @Binding var player: Player
    @State var roomLatitude = ""
    @State var roomLongitude = ""
    var body: some View {
        VStack {
            
            GameruleSettingsView(room: $room, hour: $hour, minute: $minute, killerCaptureRange: $killerCaptureRange, survivorPositionTransmissionInterval: $survivorPositionTransmissionInterval, escapeTime: $escapeTime, escapeRange: $escapeRange)
            
            Spacer()
            
            Button(action: {
                model.playerInvitePushed = true
                time = hour * 60 + (minute + 1)
                RDDAO.updateGamerule(roomId: room.id, timelimit: time, killerCaptureRange: killerCaptureRange, survivorPositionTransmissionInterval: survivorPositionTransmissionInterval, escapeTime: escapeTime, hour: hour, minute: minute, escapeRange: escapeRange, roomLatitude: roomLongitude, roomLongitude: roomLongitude)
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
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameFlag.isEscaping) {
                EscapeTimeView(setDate: Calendar.current.date(byAdding: .second, value: (Int(gamerule["escapeTime"] ?? "99")! * 60), to: Date())!)
            })
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameFlag.isGameStarted) {
                GameView(players: $players, roomId: $room.id, player: $player, gamerule: $gamerule, time: time)
            })
            
        }
        .onAppear{
            player.role = "killer"
            let location = requestLocation().roomLocation
            roomLatitude = location["roomLatitude"] ?? "0"
            roomLongitude = location["roomLongitude"] ?? "0"
            
            
            roomInit(room: room)
            RDDAO.getGameRule(roomId: room.id) { (result) in
                gamerule = result
            }
            RDDAO.getPlayers(roomId: room.id) { (result) in
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
        .onDisappear{
            player.role = ""
            roomDel(room: room.id)
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
    
    private func roomDel(room: String) {
        RDDAO.deleteRoom(roomId: room)
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

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
