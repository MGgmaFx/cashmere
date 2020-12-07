//
//  JoinRoomView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct JoinRoomView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        VStack {
            Spacer()
            Text("JoinRoom View").font(.title)
            Spacer()
            Button(action: {
                self.model.joinRoomViewPushed = false
            }) {
                Text("もどる")
                .frame(width: 240, height: 60, alignment: .center)
            }
            
            .background(Color.gray)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
        }
        .navigationBarHidden(true)
    }
}
