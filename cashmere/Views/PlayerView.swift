//
//  PlayerView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct PlayerView: View {
    var body: some View {
        List {
            PlayerListRow()
            PlayerListRow()
            PlayerListRow()
            PlayerListRow()
            PlayerListRow()
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
    }
}
