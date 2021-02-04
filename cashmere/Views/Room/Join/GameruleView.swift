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
                Text("制限時間").foregroundColor(Color.white)
                Spacer()
                Text(gamerule["hour"] ?? "取得中...").foregroundColor(Color.white)
                Text("時間").foregroundColor(Color.white)
                Text(gamerule["minute"] ?? "取得中...").foregroundColor(Color.white)
                Text("分").foregroundColor(Color.white)
            }
            .padding()
            HStack {
                Text("逃走時間").foregroundColor(Color.white)
                Spacer()
                Text(gamerule["escapeTime"] ?? "取得中...").foregroundColor(Color.white)
                Text("分").foregroundColor(Color.white)
            }
            .padding()
            HStack {
                Text("逃走範囲").foregroundColor(Color.white)
                Spacer()
                Text(gamerule["escapeRange"] ?? "取得中...").foregroundColor(Color.white)
                Text("m").foregroundColor(Color.white)
            }
            .padding()
            HStack {
                Text("鬼の捕獲範囲").foregroundColor(Color.white)
                Spacer()
                Text(gamerule["killerCaptureRange"] ?? "取得中...").foregroundColor(Color.white)
                Text("m").foregroundColor(Color.white)
            }
            .padding()
            HStack {
                Text("生存者の位置情報送信間隔").foregroundColor(Color.white)
                Spacer()
                Text(gamerule["survivorPositionTransmissionInterval"] ?? "取得中...").foregroundColor(Color.white)
                Text("分").foregroundColor(Color.white)
            }
            .padding()
            
        }.onAppear{
            RDDAO.getGameRule(roomId: roomId) { (result) in
                gamerule = result
            }
        }
    }
}
