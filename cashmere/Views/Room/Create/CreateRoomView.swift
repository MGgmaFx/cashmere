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
            
            // ゲームルール設定ビュー(初期表示)
            VStack {
                GameruleSettingsView(gameSetting: $gameSetting)
            }.padding()
            .padding(.top, 30)
                
            Spacer()
            
            // 招待ボタン(初期表示)
            Button(action: {
                tappedInvitedButton()
            }) {
                Text("プレイヤーを招待する")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .sheet(isPresented: $model.playerInvitePushed) {
                PlayerInviteView()
                    .environmentObject(room)
            }
            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "E94822"))))
            
            // 戻るボタン(初期表示)
            Button(action: {
                model.createRoomViewPushed = false
            }) {
                Text("もどる").foregroundColor(Color.black)
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "C9E8F1"))))
            
            // 逃走時間ビュー(フラグ制御)
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isEscaping) {
                let escapeTime = room.rule.escapeTime
                let startDate = getStartTime(time: escapeTime, to: Date())
                EscapeTimeView(startDate: startDate)
            })
            
            // ゲームビュー(フラグ制御)
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
            // ゲーム初期化
            roomInit(room: room)
        }
        .navigationBarBackButtonHidden(true)
        .onTapGesture {
            UIApplication.shared.closeKeyboard()
        }
    }
    
    private func tappedInvitedButton() {
        model.playerInvitePushed = true
        // ルールモデルの反映
        ruleInit()
        // ルールをDBに登録
        RDDAO.updateGamerule(room: room)
    }
    
    private func ruleInit() {
        // ルールをモデルに設定
        room.rule.escapeRange = gameSetting.escapeRange
        room.rule.escapeTime = gameSetting.escapeTime
        room.rule.killerCaptureRange = gameSetting.killerCaptureRange
        room.rule.survivorPositionTransmissionInterval = gameSetting.survivorPositionTransmissionInterval
        let hour = gameSetting.hour
        let minute = gameSetting.minute
        room.rule.toTime(hour: hour, minute: minute)
    }
    private func roomInit(room: Room) {
        // ホストの役割を設定
        room.me.role = .killer
        // ホストの状態を設定
        room.me.captureState = .tracking
        // ルームの位置情報を設定
        getLocation()
        // ルームの状態をDBへ登録
        RDDAO.updateRoomStatus(roomId: room.id, state: .wating)
        // プレイヤーを追加(ホスト)
        RDDAO.addPlayer(roomId: room.id, player: room.me)
    }

    private func roomDel(room: String) {
        RDDAO.deleteRoom(roomId: room)
    }

    private func getLocation() {
        requestLocation().getLocation(comp: { roomLocation in
            let roomLatitude = roomLocation["roomLatitude"]!
            let roomLongitude = roomLocation["roomLongitude"]!
            room.point = Position(latitude: roomLatitude, longitude: roomLongitude)
            // ルームの位置情報の登録
            RDDAO.updatePosition(room: room)
        })
    }
    
    private func getStartTime(time: Int, to:Date) -> Date {
        let sec = time * 60
        let time = Calendar.current.date(byAdding: .second, value: sec, to: to)!
        return time
    }
    
}

extension UIApplication {
    func closeKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
