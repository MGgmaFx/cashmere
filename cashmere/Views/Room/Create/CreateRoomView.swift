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
    @EnvironmentObject var room: Room
    @State var gameSetting: GameSettingObserve = GameSettingObserve()

    var body: some View {
        VStack {
            VStack {
                GameruleSettingsView(gameSetting: $gameSetting)
            }.padding()
            .padding(.top, 30)
                
            Spacer()
            
            Button(action: {
                model.playerInvitePushed = true
                // ルールモデルの反映
                ruleInit()
                RDDAO.updateGamerule(room: room)
                RDDAO.updatePosition(room: room)
                RDDAO.getGameRule(room: room) { rule in
                    if let r = rule {
                        self.room.rule = r
                    }
                    // FIXME: nilの場合は何もしない
                }
            }) {
                Text("プレイヤーを招待する")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .sheet(isPresented: $model.playerInvitePushed) {
                PlayerInviteView()
                    .environmentObject(room)
            }
            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "E94822"))))
            
            Button(action: {
                model.createRoomViewPushed = false
            }) {
                Text("もどる").foregroundColor(Color.black)
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "C9E8F1"))))
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isEscaping) {
                let escapeTime = room.rule.escapeTime
                let dispTime = Calendar.current.date(byAdding: .second, value: escapeTime * 60, to: Date())!
                EscapeTimeView(setDate: dispTime)
            })
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isGameStarted) {
                GameView()
            })
            
        }
        .frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
        ).background(Color(UIColor(hex: "212121"))).edgesIgnoringSafeArea(.all)
        .onAppear{
            roomInit(room: room)
            getLocation()
            RDDAO.updatePosition(room: room)
            RDDAO.getPlayers(room: room) { (players) in
                room.players = players
                for player in players {
                    // HELP: ここは何をしているんだ？
                    if room.me.id == player.id {
                        room.me.latitude = player.latitude
                        room.me.longitude = player.longitude
                        room.me.onlineStatus = player.onlineStatus
                        room.me.captureState = player.captureState
                        if room.me.captureState == .captured {
                            gameEventFlag.isCaptured = true
                        }
                    }
                }
                if gameEventFlag.isGameStarted {
                    checkAllCaught(plyers: room.players){ (isAllCaught) in
                        if isAllCaught {
                            gameEventFlag.isGameOver = isAllCaught
                        }
                    }
                }
            }
            
        }
        .onDisappear{
//            roomDel(room: room.id)
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    }
    
    private func ruleInit() {
        room.rule.escapeRange = gameSetting.escapeRange
        room.rule.escapeTime = gameSetting.escapeTime
        room.rule.killerCaptureRange = gameSetting.killerCaptureRange
        room.rule.survivorPositionTransmissionInterval = gameSetting.survivorPositionTransmissionInterval
        let hour = gameSetting.hour
        let minute = gameSetting.minute
        room.rule.toTime(hour: hour, minute: minute)
    }
    private func roomInit(room: Room) {
        room.me.role = .killer
        room.me.captureState = .tracking
        RDDAO.updateRoomStatus(roomId: room.id, state: .wating)
        RDDAO.addPlayer(roomId: room.id, player: room.me)
    }

    private func roomDel(room: String) {
//        player.role = ""
//        player.captureState = ""
        RDDAO.deleteRoom(roomId: room)
    }

    private func checkAllCaught(plyers: [Player], completionHandler: @escaping (Bool) -> Void) {
        var isAllCaught = true
        for player in room.players {
            if player.captureState != .captured && player.role == .survivor {
                isAllCaught = false
            }
        }
        completionHandler(isAllCaught)
    }

    private func getLocation() {
        requestLocation().getLocation(comp: { roomLocation in
            let roomLatitude = roomLocation["roomLatitude"]!
            let roomLongitude = roomLocation["roomLongitude"]!
            room.point = Position(latitude: roomLatitude, longitude: roomLongitude)
        })
    }
    
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
