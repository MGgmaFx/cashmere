//
//  ProfileSettingsView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/10.
//

import SwiftUI
import FirebaseAuth

struct ProfileSettingsView: View {
    @EnvironmentObject var model: Model
    @Binding var player: Player
    var body: some View {
        VStack {
            Spacer()
            Text("ProfileSettings View")
            Spacer()
            
            HStack {
                Text("プレイヤー名").padding()
                TextField("プレイヤー名を入力", text: $player.name).textFieldStyle(RoundedBorderTextFieldStyle())
            }
            Spacer()
            Button(action: {
                do {
                    try Auth.auth().signOut()
                    model.profileSettingsViewPushed = false
                } catch let signOutError as NSError {
                    print("SignOut Error: %@", signOutError)
                }
            }) {
                Text("ログアウト")
            }
            .buttonStyle(CustomButtomStyle(color: Color.red))
        }
    }
}
