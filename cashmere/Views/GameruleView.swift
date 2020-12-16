//
//  GameruleView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/15.
//

import SwiftUI

struct GameruleView: View {
    var RDDAO = RealtimeDatabeseDAO()
    @State var gamerule: [String : String] = [:]
    @Binding var roomId: String
    var body: some View {
        VStack {
            
        }.onAppear{
            RDDAO.getGameRule(roomId: roomId) { (result) in
                gamerule = result
            }
        }
    }
}
