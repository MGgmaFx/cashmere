//
//  InvitedPlayerListView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/14.
//

import SwiftUI

struct InvitedPlayerListView: View {
    @EnvironmentObject var room: Room
    var body: some View {
        VStack {
            Text("プレイヤー一覧")
                .foregroundColor(.white)
                .padding()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(room.players, id: \.id) { player in
                        VStack {
                            Image(systemName: "figure.walk")
                                .resizable()
                                .frame(width: 40, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.blue)
                            Text(player.id)
                                .foregroundColor(.white)
                        }
                        .padding()
                    }
                }
            }
        }

    }
}
