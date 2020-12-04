//
//  CreateRoom.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct CreateRoomView: View {
    @State var isPresented = false
    @EnvironmentObject var model: Model
    var body: some View {
        VStack {
            Spacer()
            Text("CreateRoom View").font(.title)
            Spacer()
            Button("もどる") {
                self.model.createRoomViewPushed = false
            }
            .frame(width: 240, height: 60, alignment: .center)
            .background(Color.gray)
            .cornerRadius(20)
            .padding()
            .foregroundColor(Color.white)
            Button("ゲーム開始") {
                self.isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented, content: GameView.init)
            .frame(width: 240, height: 60, alignment: .center)
            .background(Color.blue)
            .cornerRadius(20)
            .padding()
            .foregroundColor(Color.white)
        }.navigationBarBackButtonHidden(true)
    }
}
