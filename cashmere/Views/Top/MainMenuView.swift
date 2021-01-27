//
//  MainMenuView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI
import FirebaseAuth

struct MainMenuView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var session: SessionStore
    @State var player = Player()
    func getUser () {
          session.listen()
    }
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(width: 280, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Spacer()
                if Auth.auth().currentUser == nil {
                    NavigationLink(destination: LoginView().navigationBarBackButtonHidden(true), isActive: $model.loginViewPushed) {
                        Button(action: {
                            model.loginViewPushed = true
                        }) {
                            Text("ログイン")
                        }
                        .buttonStyle(CustomButtomStyle(color: Color.orange))
                    }
                } else {
                    NavigationLink(destination: JoinRoomView(player: $player), isActive: $model.joinRoomViewPushed) {
                        Button(action: {
                            model.joinRoomViewPushed = true
                        }) {
                            Text("ルームに参加する")
                        }
                        .buttonStyle(CustomButtomStyle(color: Color.blue))
                    }
                    NavigationLink(destination: CreateRoomView(player: $player), isActive: $model.createRoomViewPushed) {
                        Button(action: {
                            model.createRoomViewPushed = true
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
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .edgesIgnoringSafeArea(.all)
        }.onAppear(perform: getUser)
    }
}


struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
