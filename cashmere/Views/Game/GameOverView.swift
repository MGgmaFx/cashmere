//
//  GameOverView.swift
//  cashmere
//
//  Created by 志村豪気 on 2021/01/28.
//

import SwiftUI

struct GameOverView: View {
    var body: some View {
        VStack {
            Image("captured_logo")
            Image("captured")
        }
    }
}

struct GameOverView_Previews: PreviewProvider {
    static var previews: some View {
        GameOverView()
    }
}
