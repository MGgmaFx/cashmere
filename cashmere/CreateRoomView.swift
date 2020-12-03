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
            Text("CreateRoom View")
            Button("戻る") {
                self.model.createRoomViewPushed = false
            }
            Button("ゲーム開始") {
                self.isPresented.toggle()
            }
            .fullScreenCover(isPresented: $isPresented, content: GameView.init)
        }.navigationBarBackButtonHidden(true)
    }
}
