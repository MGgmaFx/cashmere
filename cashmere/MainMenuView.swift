//
//  MainMenuView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    Image(systemName: "person.fill")
                        .frame(width:70, height: 50)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 2))
                        .padding(.top, 60)
                        .padding(.horizontal, 30)
                }
                Spacer()
                Text("Blue Cat").font(.title)
                Spacer()
                NavigationLink(destination: JoinRoomView(), isActive: self.$model.joinRoomViewPushed) {
                    Button(action: {
                        self.model.joinRoomViewPushed = true
                    }) {
                        Text("ルームに参加する")
                    }
                    .frame(width: 240, height: 60, alignment: .center)
                    .background(Color.gray)
                    .cornerRadius(20)
                    .foregroundColor(Color.white)
                    .padding()
                }
                NavigationLink(destination: CreateRoomView(), isActive: self.$model.createRoomViewPushed) {
                    Button(action: {
                        self.model.createRoomViewPushed = true
                    }) {
                        Text("ルームをつくる")
                    }
                    .frame(width: 240, height: 60, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 40)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }
    }
}

