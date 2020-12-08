//
//  CreateRoom.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI
import Firebase

struct CreateRoomView: View {
    @State var isPresented = false
    @EnvironmentObject var model: Model
    var ref = Database.database().reference()
    var body: some View {
        VStack {
            Spacer()
            Text("CreateRoom View").font(.title)
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
                self.isPresented.toggle()
            }) {
                Text("ゲーム開始")
                    .frame(width: 240, height: 60, alignment: .center)
            }
            .fullScreenCover(isPresented: $isPresented, content: GameView.init)
            .background(Color.blue)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
            Button(action: {
                var room = Room(name: "testRoom")
                self.ref.child("rooms").child(room.id).setValue(["username": "testuser"])
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
