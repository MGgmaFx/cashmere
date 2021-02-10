//
//  PlayerListRow.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct PlayerListRow:View {
    let playerName: String
    let captureState: Player.CaptureStatus
    let role: Player.Role
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .foregroundColor(Color.blue)
                .frame(width: 50, height: 50)
            Text(playerName).foregroundColor(Color.white)
            Spacer()
            if role == .killer {
                Text("鬼").foregroundColor(Color.red)
            } else {
                Text("逃走者").foregroundColor(Color.blue)
            }
            Spacer()
            if captureState == .escaping {
                Text("逃走中").foregroundColor(.white)
            } else if captureState == .tracking {
                Text("追跡中").foregroundColor(.white)
            } else if captureState == .captured {
                Text("確保済み").foregroundColor(Color.red)
            } else {
                Text(captureState.rawValue)
            }
        }.background(Color(UIColor(hex: "212121")))
    }
}
