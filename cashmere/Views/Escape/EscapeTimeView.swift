//
//  EscapeTimeView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/16.
//

import SwiftUI

struct EscapeTimeView: View {
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
            Text("逃走時間").foregroundColor(.red).font(.largeTitle)
            Spacer()
            
            TimerFunc(from: startDate)
                .font(.title)
                .onAppear(perform: {
                    // timerクロージャの設定
                    _ = self.timer
                })
            
            Spacer()
            Text("※できるだけ遠くに逃げてください!!").foregroundColor(.white).font(.footnote)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    func TimerFunc(from date:Date) -> Text{
        // 現在時刻とゲーム開始時刻の差分を取得
        let cal = Calendar(identifier: .japanese)
        let timeVal = cal.dateComponents([.day,.hour,.minute,.second], from: nowDate,to: startDate)
        
        if timeVal.second! < 0 && timeVal.minute == 0 {
            return Text("開始中...")
                .foregroundColor(.white)
                .font(.system(size: 70, weight: .regular, design: .default))
        }
        
        return Text(String(format: "%02d:%02d",
                           timeVal.minute ?? 00,
                           timeVal.second ?? 00))
            .foregroundColor(.red)
            .font(.system(size: 100, weight: .regular, design: .default))
        
    }
}
