//
//  GameruleView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/15.
//

import SwiftUI

struct GameruleView: View {
    var RDDAO = RealtimeDatabeseDAO()
    @EnvironmentObject var room: Room
    var body: some View {
        VStack {
            HStack {
                Text("制限時間").foregroundColor(Color.white)
                Spacer()
                Text(room.rule.toHour()).foregroundColor(Color.white)
                Text("時間").foregroundColor(Color.white)
                Text(room.rule.toMinute()).foregroundColor(Color.white)
                Text("分").foregroundColor(Color.white)
            }
            .padding()
            HStack {
                Text("逃走時間").foregroundColor(Color.white)
                Spacer()
                Text(String(room.rule.escapeTime)).foregroundColor(Color.white)
                Text("分").foregroundColor(Color.white)
            }
            .padding()
            HStack {
                Text("逃走範囲").foregroundColor(Color.white)
                Spacer()
                Text(String(room.rule.escapeRange)).foregroundColor(Color.white)
                Text("m").foregroundColor(Color.white)
            }
            .padding()
            HStack {
                Text("鬼の捕獲範囲").foregroundColor(Color.white)
                Spacer()
                Text(String(room.rule.killerCaptureRange)).foregroundColor(Color.white)
                Text("m").foregroundColor(Color.white)
            }
            .padding()
            HStack {
                Text("生存者の位置情報送信間隔").foregroundColor(Color.white)
                Spacer()
                Text(String(room.rule.survivorPositionTransmissionInterval)).foregroundColor(Color.white)
                Text("分").foregroundColor(Color.white)
            }
            .padding()
            
        }
    }
}
