//
//  GameruleSettingsView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/17.
//

import SwiftUI

struct GameruleSettingsView: View {
    @Binding var room: Room
    @Binding var hour: Int
    @Binding var minute: Int
    @Binding var killerCaptureRange: Int
    @Binding var survivorPositionTransmissionInterval: Int
    @Binding var escapeTime: Int
    var body: some View {
        VStack {
            HStack {
                Text("ルーム名")
                    .padding(20)
                
                Spacer()
                
                TextField("ルーム名を入力", text: $room.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            HStack {
                Text("制限時間")
                    .padding(20)
                
                Spacer()
                
                Picker("", selection: $hour) {
                    ForEach(0 ..< 100) { num in
                        Text(String(num) + "時間")
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
                Picker("", selection: $minute) {
                    ForEach(1 ..< 60) { num in
                        Text(String(num) + "分")
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
            }
            HStack {
                Text("鬼の捕獲範囲")
                    .padding(20)
                
                Spacer()
                
                Picker("", selection: $killerCaptureRange) {
                    ForEach(1 ..< 100) { num in
                        Text(String(num) + "m")
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
            }
            
            HStack {
                Text("生存者の位置情報送信間隔")
                    .padding(20)
                
                Spacer()
                
                Picker("", selection: $survivorPositionTransmissionInterval) {
                    ForEach(1 ..< 100) { num in
                        Text(String(num) + "分")
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
            }
            
            HStack {
                Text("逃走時間")
                    .padding(20)
                
                Spacer()
                Picker("", selection: $escapeTime) {
                    ForEach(1 ..< 60) { num in
                        Text(String(num) + "分")
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
            }
        }
        .background(Color(red: 0.95, green: 0.95, blue: 1.0))
        .cornerRadius(10)
    }
}
