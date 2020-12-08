//
//  CreateRoom.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI
import Firebase

struct CreateRoomView: View {
    @State var hour = 1
    @State var minute = 0
    @State var time = 0
    @State var isPresented = false
    @EnvironmentObject var model: Model
    @State var roomName = "鬼ごっこルーム"
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
                    TextField("ルーム名を入力", text: self.$roomName)
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
                self.isPresented.toggle()
            }) {
                Text("ゲーム開始")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .fullScreenCover(isPresented: $isPresented) {
                GameView(time: $time)
            }
            .background(Color.blue)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
            Button(action: {
                let room = Room(name: self.roomName)
                guard let key = ref.child(room.id).key else { return }
                let post = ["roomname": room.name,
                            "username": "testuser"]
                let childUpdates = ["/\(key)": post]
                ref.updateChildValues(childUpdates)
                }) {
                    Text("FireBaseに書き込み")
            }
            .frame(width: 240, height: 60, alignment: .center)
            .background(Color.red)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
        }
        .navigationBarBackButtonHidden(true)
    }
}
struct CreateRoomView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRoomView()
    }
}

