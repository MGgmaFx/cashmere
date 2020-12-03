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
            Text("MainMenu View")
            NavigationLink(destination: CreateRoomView(), isActive: self.$model.createRoomViewPushed) {
                Button(action: {
                    self.model.createRoomViewPushed = true
                }) {
                    Text("ルーム作成")
                }
            }
        }
    }
   }
}
