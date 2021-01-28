//
//  PlayerListRow.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct PlayerListRow:View {
    let playerName: String
    let onlineStatus: String
    let role: String
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .foregroundColor(Color.blue)
                .frame(width: 50, height: 50)
            Text(playerName).foregroundColor(Color.primary)
            Spacer()
            if role == "killer" {
                Text("鬼").foregroundColor(Color.red)
            } else {
                Text("逃走者").foregroundColor(Color.blue)
            }
            Spacer()
            if onlineStatus == "online" {
                Text("オンライン")
            } else {
                Text("オフライン").foregroundColor(Color.red)
            }
        }
    }
}
