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
    @State var isPresentedGameView = false
    @State var isPresentedQRCodeView = false
    @State var room = Room(name: "鬼ごっこルーム")
    @State var playerList: [String] = []
    var ref = Database.database().reference()
    var body: some View {
        VStack {
            Spacer()
            Text("CreateRoom View").font(.title)
            Spacer()
            VStack {
                HStack {
                    Text("ルーム名")
                        .padding()
                    TextField("ルーム名を入力", text: self.$room.name)
                        
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                }
                HStack {
                    Text("制限時間")
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
                
                Text("プレイヤー一覧").padding()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack {
                        ForEach(playerList, id: \.self) { value in
                            VStack {
                                Image(systemName: "face.smiling.fill")
                                    .resizable()
                                    .frame(width: 80, height: 80, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                    .foregroundColor(.blue)
                                Text(value)
                            }.padding()
                        }
                    }
                }
            }
            .background(Color(red: 0.95, green: 0.95, blue: 1.0))
            .cornerRadius(10)
            
            Spacer()
            Button(action: {
                self.model.createRoomViewPushed = false
            }) {
                Text("もどる")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .background(Color.gray)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
            Button(action: {
                self.time = self.hour * 60 + self.minute
                let data = ["status": "playing"]
                self.ref.child(room.id).updateChildValues(data)
                self.isPresentedGameView.toggle()
            }) {
                Text("ゲーム開始")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .fullScreenCover(isPresented: $isPresentedGameView) {
                GameView(time: $time)
            }
            .background(Color.blue)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
            Button(action: {
                let data = ["roomname": room.name,
                            "timelimit": String(self.hour * 60 + self.minute),
                            "username": "testuser"]
                self.ref.child(room.id).updateChildValues(data)
                }) {
                    Text("FireBaseに書き込み")
            }
            .frame(width: 240, height: 60, alignment: .center)
            .background(Color.red)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
            Button(action: {
                self.time = self.hour * 60 + self.minute
                self.isPresentedQRCodeView.toggle()
            }) {
                Text("QRCode表示")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .sheet(isPresented: $isPresentedQRCodeView) {
                QRCodeView(room: $room)
            }
            .background(Color.green)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
        }
        .onAppear{
            roomInit(room: self.room)
            ref.child(room.id).child("players").observe(DataEventType.value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                playerList = []
                for (_, value) in postDict {
                    if let followingUsers = value as? [String : String] {
                        for (_, user) in followingUsers {
                            playerList.append(user)
                        }
                    }
                }
            })
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
        self.ref.child(room.id).setValue(["status": "wating"])
        self.ref.child(room.id).child("players").child(player.id).setValue(["playername": player.name])
    }
    
    private func roomDel(room: Room) {
        self.ref.child(room.id).removeValue()
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

