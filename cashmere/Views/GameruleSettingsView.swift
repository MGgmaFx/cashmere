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
                    .foregroundColor(.black)
                
                Spacer()
                
                TextField("ルーム名を入力", text: $room.name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.primary)
                    .padding()
            }
            .padding(.vertical)
            HStack {
                Text("制限時間")
                    .padding(20)
                    .foregroundColor(.black)
                
                Spacer()
                
                Picker("", selection: $hour) {
                    ForEach(0 ..< 100) { num in
                        Text(String(num) + "時間")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
                Picker("", selection: $minute) {
                    ForEach(1 ..< 60) { num in
                        Text(String(num) + "分")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
            }
            .padding(.vertical)
            HStack {
                Text("鬼の捕獲範囲")
                    .padding(20)
                    .foregroundColor(.black)
                
                Spacer()
                
                Picker("", selection: $killerCaptureRange) {
                    ForEach(1 ..< 100) { num in
                        Text(String(num) + "m")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
            }
            .padding(.vertical)
            HStack {
                Text("生存者の位置情報送信間隔")
                    .padding(20)
                    .foregroundColor(.black)
                
                Spacer()
                
                Picker("", selection: $survivorPositionTransmissionInterval) {
                    ForEach(1 ..< 100) { num in
                        Text(String(num) + "分")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
            }
            .padding(.vertical)
            HStack {
                Text("逃走時間")
                    .padding(20)
                    .foregroundColor(.black)
                
                Spacer()
                Picker("", selection: $escapeTime) {
                    ForEach(1 ..< 60) { num in
                        Text(String(num) + "分")
                            .foregroundColor(.black)
                    }
                }
                .frame(width: 120, height: 60, alignment: .center)
                .labelsHidden()
                .compositingGroup()
                .clipped()
                
            }
            .padding(.vertical)
        }
        .background(Color(red: 0.8, green: 0.8, blue: 0.85))
        .cornerRadius(10)
    }
}
