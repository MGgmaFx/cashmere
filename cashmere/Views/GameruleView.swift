//
//  GameruleView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/15.
//

import SwiftUI

struct GameruleView: View {
    var RDDAO = RealtimeDatabeseDAO()
    @State var gamerule: [String : String] = [:]
    @Binding var roomId: String
    var body: some View {
        VStack {
            HStack {
                Text("制限時間")
                Spacer()
                Text(gamerule["timelimit"] ?? "取得中...")
                Text("分")
            }
            .padding()
            HStack {
                Text("鬼の捕獲範囲")
                Spacer()
                Text(gamerule["demonCaptureRange"] ?? "取得中...")
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
        }.onAppear{
            RDDAO.getGameRule(roomId: roomId) { (result) in
                gamerule = result
            }
        }
    }
}
