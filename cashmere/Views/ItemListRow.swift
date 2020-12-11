//
//  ItemListRow.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct ItemListRow:View {
    var body: some View {
        HStack {
            Image(systemName: "cube")
                .resizable()
                .foregroundColor(Color.orange)
                .frame(width: 50, height: 50)
            Text("Test Item").foregroundColor(Color.orange)
            Spacer()
        }
    }
}

struct ItemListRow_Previews: PreviewProvider {
    static var previews: some View {
        ItemListRow()
            .previewLayout(.fixed(width: 300, height: 70))
    }
}
