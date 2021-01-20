//
//  ItemListRow.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct ItemListRow:View {
    let item: Item
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(systemName: item.imageName)
                    .resizable()
                    .foregroundColor(Color.orange)
                    .frame(width: 50, height: 50)
                Spacer()
                VStack {
                    Text(item.name).foregroundColor(Color.black)
                    Text(item.description).foregroundColor(Color.gray)
                }
                Spacer()
                Text("x \(item.amount)")
                Spacer()
            }
        }
    }
}

//struct ItemListRow_Previews: PreviewProvider {
//    let item = Item(id: 1, name: "test", imageName: "cube", description: "test-description", amount: 1)
//    static var previews: some View {
//        ItemListRow(item: item)
//            .previewLayout(.fixed(width: 300, height: 70))
//    }
//}
