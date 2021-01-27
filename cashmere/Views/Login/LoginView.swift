//
//  Login.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/22.
//

import SwiftUI
import GoogleSignIn
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        VStack {
            Spacer()
            GoogleSignInButton()
            Spacer()
            if Auth.auth().currentUser?.uid != nil {
                Text("ログインしました")
            }
            Button(action: {
                model.loginViewPushed = false
            }) {
                Text("もどる")
            }.buttonStyle(CustomButtomStyle(color: Color.gray))
        }
    }
}
