//
//  TimerView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI
struct TimerView : View {
    @EnvironmentObject var gameFlag: GameEventFlag
    @State var nowD: Date = Date()
    
    @Binding var setDate:Date
   
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.nowD = Date()
        }
    }
   
    var body: some View {
        TimerFunc(from: setDate)
            .font(.title)
            .onAppear(perform: {
                _ = self.timer
            })
    }

   func TimerFunc(from date:Date) -> Text{
        let cal = Calendar(identifier: .japanese)

        let timeVal = cal.dateComponents([.day,.hour,.minute,.second], from: nowD,to: setDate)
    
        if timeVal.second == 0 && timeVal.minute == 0 && timeVal.hour == 0 && timeVal.day == 0{
            gameFlag.isTimeOut = true
            gameFlag.isGameOver = true
        }
    
        if timeVal.second! < 0 && timeVal.minute == 0 {
            return Text("開始中...")
        }

        return Text(String(format: "残り時間　%02d:%02d:%02d:%02d",
        timeVal.day ?? 00,
        timeVal.hour ?? 00,
        timeVal.minute ?? 00,
        timeVal.second ?? 00))
            .foregroundColor(Color.white)
       
    }

}
