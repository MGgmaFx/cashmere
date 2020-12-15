//
//  CreateRoom.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI
import Firebase

struct CreateRoomView: View {
    @Binding var player: Player
    @EnvironmentObject var model: Model
    @State var hour = 1
    @State var minute = 0
    @State var time = 60
    @State var room = Room(name: "鬼ごっこルーム")
    @State var demonCaptureRange = 10
    @State var survivorPositionTransmissionInterval = 1
    let RDDAO = RealtimeDatabeseDAO()
    var body: some View {
        VStack {
            Spacer()
            Text("CreateRoom View").font(.title)
            Spacer()
            VStack {
                HStack {
                    Text("ルーム名")
                        .padding(20)
                    
                    Spacer()
                    
                    TextField("ルーム名を入力", text: self.$room.name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    Text("制限時間")
                        .padding(20)
                    
                    Spacer()
                    
                    Picker("", selection: $hour) {
                        ForEach(0 ..< 100) { num in
                            Text(String(num) + "時間")
                        }
                    }
                    .frame(width: 120, height: 60, alignment: .center)
                    .labelsHidden()
                    .compositingGroup()
                    .clipped()
                    
                    Picker("", selection: $minute) {
                        ForEach(0 ..< 60) { num in
                            Text(String(num) + "分")
                        }
                    }
                    .frame(width: 120, height: 60, alignment: .center)
                    .labelsHidden()
                    .compositingGroup()
                    .clipped()
                    
                }
                HStack {
                    Text("鬼の捕獲範囲")
                        .padding(20)
                    
                    Spacer()
                    
                    Picker("", selection: $demonCaptureRange) {
                        ForEach(1 ..< 100) { num in
                            Text(String(num - 1) + "m")
                        }
                    }
                    .frame(width: 120, height: 60, alignment: .center)
                    .labelsHidden()
                    .compositingGroup()
                    .clipped()
                }
                
                HStack {
                    Text("生存者の位置情報送信間隔")
                        .padding(20)
                    
                    Spacer()
                    
                    Picker("", selection: $survivorPositionTransmissionInterval) {
                        ForEach(1 ..< 100) { num in
                            Text(String(num - 1) + "分")
                        }
                    }
                    .frame(width: 120, height: 60, alignment: .center)
                    .labelsHidden()
                    .compositingGroup()
                    .clipped()
                }
            }
            .background(Color(red: 0.95, green: 0.95, blue: 1.0))
            .cornerRadius(10)
            
            Spacer()
            
            Button(action: {
                time = hour * 60 + minute
                RDDAO.updateGamerule(roomId: room.id, timelimit: time, demonCaptureRange: demonCaptureRange, survivorPositionTransmissionInterval: survivorPositionTransmissionInterval)
                model.playerInvitePushed.toggle()
            }) {
                Text("プレイヤーを招待する")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .sheet(isPresented: $model.playerInvitePushed) {
                PlayerInviteView(room: $room, time: $time, player: $player)
            }
            .buttonStyle(CustomButtomStyle(color: Color.green))
            
            Button(action: {
                self.model.createRoomViewPushed = false
            }) {
                Text("もどる")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .buttonStyle(CustomButtomStyle(color: Color.gray))
            
        }
        .onAppear{
            roomInit(room: self.room)
        }
        .onDisappear{
            roomDel(room: self.room)
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

//struct CreateRoomView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateRoomView(player: Player(name: ""))
//    }
//}

