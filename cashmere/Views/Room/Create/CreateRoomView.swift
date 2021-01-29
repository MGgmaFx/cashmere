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
    @EnvironmentObject var gameEventFlag: GameEventFlag
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
                RDDAO.updateGamerule(roomId: room.id, timelimit: time, killerCaptureRange: killerCaptureRange, survivorPositionTransmissionInterval: survivorPositionTransmissionInterval, escapeTime: escapeTime, hour: hour, minute: minute, escapeRange: escapeRange, roomLatitude: roomLatitude, roomLongitude: roomLongitude)
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
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isEscaping) {
                EscapeTimeView(setDate: Calendar.current.date(byAdding: .second, value: (Int(gamerule["escapeTime"] ?? "99")! * 60), to: Date())!)
            })
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isGameStarted) {
                GameView(players: $players, roomId: $room.id, player: $player, gamerule: $gamerule, time: time)
            })
            
        }
        .onAppear{
            roomInit(room: room)
            getLocation()
            RDDAO.getGameRule(roomId: room.id) { (result) in
                gamerule = result
            }
            RDDAO.getPlayers(roomId: room.id) { (result) in
                for playerDB in players {
                    if player.id == playerDB.id {
                        player.latitude = playerDB.latitude
                        player.longitude = playerDB.longitude
                        player.onlineStatus = playerDB.onlineStatus
                        player.role = playerDB.role
                        player.captureState = playerDB.captureState
                        if player.captureState == "captured" {
                            gameEventFlag.isCaptured = true
                        }
                    }
                }
                players = result
                if gameEventFlag.isGameStarted {
                    checkAllCaught(plyers: players){ (isAllCaught) in
                        if isAllCaught {
                            gameEventFlag.isGameOver = isAllCaught
                        }
                    }
                }
            }
            
        }
        .onDisappear{
            roomDel(room: room.id)
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    }
    private func roomInit(room: Room) {
        player.role = "killer"
        player.captureState = "tracking"
        RDDAO.updateRoomStatus(roomId: room.id, state: "wating")
        RDDAO.addPlayer(roomId: room.id, playerId: player.id, playerName: player.name, captureState: player.captureState ?? "tracking", role: player.role ?? "killer")
    }
    
    private func roomDel(room: String) {
        player.role = ""
        player.captureState = ""
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
    
    private func getLocation() {
        requestLocation().getLocation(comp: { roomLocation in
            roomLatitude = roomLocation["roomLatitude"]!
            roomLongitude = roomLocation["roomLongitude"]!
        })
    }
    
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
