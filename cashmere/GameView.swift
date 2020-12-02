//
//  GameView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        VStack {
            MapView()
        }
    }
}

