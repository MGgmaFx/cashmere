//
//  EscapeTimeView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/16.
//

import SwiftUI

struct EscapeTimeView: View {
    @EnvironmentObject var gameFlag: GameEventFlag
    @State var nowD:Date = Date()
    let setDate: Date
    
    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
            self.nowD = Date()
        }
    }
    
    var body: some View {
        VStack {
            Spacer()
            Text("逃走時間").foregroundColor(.red).font(.largeTitle)
            Spacer()
            TimerFunc(from: setDate)
                .font(.title)
                .onAppear(perform: {
                    _ = self.timer
                })
            Spacer()
            Text("※できるだけ遠くに逃げてください!!").foregroundColor(.white).font(.footnote)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center).background(Color.black)
        .edgesIgnoringSafeArea(.all)
    }
    
    func TimerFunc(from date:Date)->Text{
         let cal = Calendar(identifier: .japanese)

         let timeVal = cal.dateComponents([.day,.hour,.minute,.second], from: nowD,to: setDate)

         return Text(String(format: "%02d:%02d",
         timeVal.minute ?? 00,
         timeVal.second ?? 00))
            .foregroundColor(.red)
            .font(.system(size: 100, weight: .regular, design: .default))
        
     }
}

struct EscapeTimeViewPreview: PreviewProvider {
    static var previews: some View {
        let toDate = Calendar.current.date(byAdding:.minute,value: 3,to:Date())
        EscapeTimeView(setDate: toDate!)
    }
}
