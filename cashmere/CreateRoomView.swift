//
//  CreateRoomView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct CreateRoomView: View {
    @EnvironmentObject var model: Model
    @State private var isStart: Bool = false
    var body: some View {
        VStack {
            if isStart {
                GameView()
            } else {
                Text("CreateRoom View")
            }
            Button(isStart ? "Red" : "Blue") {
                self.isStart.toggle()
            }
        }
    }
}
