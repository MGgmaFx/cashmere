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
                Text("鬼ごっこオンライン").font(.title)
                Spacer()
                NavigationLink(destination: JoinRoomView(player: $player), isActive: self.$model.joinRoomViewPushed) {
                    Button(action: {
                        self.model.joinRoomViewPushed = true
                    }) {
                        Text("ルームに参加する")
                    }
                    .buttonStyle(CustomButtomStyle(color: Color.blue))
                }
                NavigationLink(destination: CreateRoomView(player: $player), isActive: $model.createRoomViewPushed) {
                    Button(action: {
                        self.model.createRoomViewPushed = true
                    }) {
                        Text("ルームをつくる")
                    }
                    .buttonStyle(CustomButtomStyle(color: Color.blue))
                }
                NavigationLink(destination: ProfileSettingsView(player: $player), isActive: $model.profileSettingsViewPushed) {
                    Button(action: {
                        model.profileSettingsViewPushed = true
                    }) {
                        Text("設定")
                    }
                    .buttonStyle(CustomButtomStyle(color: Color.gray))
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
