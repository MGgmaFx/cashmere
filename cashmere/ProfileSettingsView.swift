//
//  ProfileSettingsView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/10.
//

import SwiftUI

struct ProfileSettingsView: View {
    @Binding var player: Player
    var body: some View {
        Spacer()
        Text("ProfileSettings View")
        Spacer()
        
        HStack {
            Text("プレイヤー名").padding()
            TextField("プレイヤー名を入力", text: $player.name).textFieldStyle(RoundedBorderTextFieldStyle())
        }
        Spacer()
    }
}
