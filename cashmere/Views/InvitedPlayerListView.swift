//
//  InvitedPlayerListView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/14.
//

import SwiftUI

struct InvitedPlayerListView: View {
    @Binding var playerList: [String]
    var body: some View {
        VStack {
            Text("プレイヤー一覧")
                .foregroundColor(.primary)
                .padding()
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(playerList, id: \.self) { value in
                        VStack {
                            Image(systemName: "figure.walk")
                                .resizable()
                                .frame(width: 40, height: 60, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                .foregroundColor(.blue)
                            Text(value)
                                .foregroundColor(.primary)
                        }
                        .padding()
                    }
                }
            }
        }

    }
}
