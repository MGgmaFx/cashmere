//
//  GameruleView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/15.
//

import SwiftUI

struct GameruleView: View {
    var RDDAO = RealtimeDatabeseDAO()
    @Binding var gamerule: [String : String]
    @Binding var roomId: String
    var body: some View {
        VStack {
            HStack {
                Text("制限時間")
                Spacer()
                Text(gamerule["hour"] ?? "取得中...")
                Text("時間")
                Text(gamerule["minute"] ?? "取得中...")
                Text("分")
            }
            .padding()
            HStack {
                Text("鬼の捕獲範囲")
                Spacer()
                Text(gamerule["killerCaptureRange"] ?? "取得中...")
                Text("m")
            }
            .padding()
            HStack {
                Text("生存者の位置情報送信間隔")
                Spacer()
                Text(gamerule["survivorPositionTransmissionInterval"] ?? "取得中...")
                Text("分")
            }
            .padding()
            HStack {
                Text("逃走時間")
                Spacer()
                Text(gamerule["escapeTime"] ?? "取得中...")
                Text("分")
            }
            .padding()
        }.onAppear{
            RDDAO.getGameRule(roomId: roomId) { (result) in
                gamerule = result
            }
        }
    }
}
