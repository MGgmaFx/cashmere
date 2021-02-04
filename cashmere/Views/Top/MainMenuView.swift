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
                    NavigationLink(destination: ProfileSettingsView(player: $player), isActive: $model.profileSettingsViewPushed) {
                    HStack {
                        Spacer()
                        
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .padding(EdgeInsets(top: 50, leading: 0, bottom: 0, trailing: 20))
                                .foregroundColor(.gray)
                                .onTapGesture {
                                    model.profileSettingsViewPushed = true
                                }
                        }
                    }
                    Image("logo_title")
                        .resizable()
                        .frame(width: 280, height: 70, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        .padding()
                    VStack {
                        TabView {
                            RuleExplanationView(imageName: "create_room")
                            RuleExplanationView(imageName: "role")
                            RuleExplanationView(imageName: "win_or_lose")
                        }
                        .tabViewStyle(PageTabViewStyle())
                    }
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
                        NavigationLink(destination: CreateRoomView(player: $player), isActive: $model.createRoomViewPushed) {
                            Button(action: {
                                model.createRoomViewPushed = true
                            }) {
                                Text("ルームをつくる")
                            }
                            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "E94822"))))
                        }
                        NavigationLink(destination: JoinRoomView(player: $player), isActive: $model.joinRoomViewPushed) {
                            Button(action: {
                                model.joinRoomViewPushed = true
                            }) {
                                Text("ルームに参加する")
                            }
                            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "F2910A"))))
                        }
                        
                    }
                }.frame(minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: .infinity
                ).background(Color(UIColor(hex: "212121"))).edgesIgnoringSafeArea(.all)
            }.onAppear(perform: getUser)
    }
}


struct MainMenuView_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuView()
    }
}
