//
//  PlayerListRow.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct PlayerListRow:View {
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle")
                .resizable()
                .foregroundColor(Color.blue)
                .frame(width: 50, height: 50)
            Text("Test Player").foregroundColor(Color.blue)
            Spacer()
        }
    }
}

struct PlayerListRow_Previews: PreviewProvider {
    static var previews: some View {
        PlayerListRow()
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
