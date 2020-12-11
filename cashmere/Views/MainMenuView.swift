//
//  MainMenuView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct MainMenuView: View {
    @EnvironmentObject var model: Model
    @State var player = Player(name: "Player")
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Text("Blue Cat").font(.title)
                Spacer()
                NavigationLink(destination: JoinRoomView(player: $player), isActive: self.$model.joinRoomViewPushed) {
                    Button(action: {
                        self.model.joinRoomViewPushed = true
                    }) {
                        Text("ルームに参加する")
                    }
                    .frame(width: 240, height: 60, alignment: .center)
                    .background(Color.blue)
                    .cornerRadius(20)
                    .foregroundColor(Color.white)
                    .padding()
                }
                NavigationLink(destination: CreateRoomView(player: $player), isActive: self.$model.createRoomViewPushed) {
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
                NavigationLink(destination: ProfileSettingsView(player: $player)) {
                    Button(action: {
                    }) {
                        Text("設定")
                    }
                    .frame(width: 240, height: 60, alignment: .center)
                    .background(Color.gray)
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


struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
