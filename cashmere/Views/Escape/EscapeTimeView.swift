//
//  EscapeTimeView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/16.
//

import SwiftUI

struct EscapeTimeView: View {
    @EnvironmentObject var room: Room
    @State var nowDate:Date = Date()
    // 開始時刻
    let startDate: Date
    
    var timer: Timer {
        // スケジューラーを設定
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            // 1秒ごとに時刻を再設定
            self.nowDate = Date()
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            if room.me.role == .killer {
                Text("待機時間").foregroundColor(.blue).font(.largeTitle)
            } else {
                Text("逃走時間").foregroundColor(.red).font(.largeTitle)
            }
            Spacer()
            
            TimerFunc(from: startDate, role: room.me.role)
                .font(.title)
                .onAppear(perform: {
                    // timerクロージャの設定
                    _ = self.timer
                })
            
            Spacer()
            if room.me.role == .killer {
                Text("※待機時間後に逃走者全員を確保してください!!").foregroundColor(.white).font(.footnote)
            } else {
                Text("※できるだけ遠くに逃げてください!!").foregroundColor(.white).font(.footnote)
            }
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    func TimerFunc(from date:Date, role:Player.Role) -> Text{
        // 現在時刻とゲーム開始時刻の差分を取得
        let cal = Calendar(identifier: .japanese)
        let timeVal = cal.dateComponents([.day,.hour,.minute,.second], from: nowDate,to: startDate)
        
        if timeVal.second! < 0 && timeVal.minute == 0 {
            return Text("開始中...")
                .foregroundColor(.white)
                .font(.system(size: 70, weight: .regular, design: .default))
        }
        
        // 色分け
        var color = Color.red
        if role == .killer {
            color = Color.blue
        }
        
        return Text(String(format: "%02d:%02d",
                           timeVal.minute ?? 00,
                           timeVal.second ?? 00))
            .foregroundColor(color)
            .font(.system(size: 100, weight: .regular, design: .default))
        
    }
}
