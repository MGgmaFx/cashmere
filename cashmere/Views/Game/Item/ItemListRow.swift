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
        ZStack {
            Color(UIColor(hex: "212121")).edgesIgnoringSafeArea(.all)
            HStack {
                Spacer()
                Image(systemName: item.imageName)
                    .resizable()
                    .foregroundColor(Color.orange)
                    .frame(width: 50, height: 50)
                Spacer()
                VStack {
                    Text(item.name).foregroundColor(Color.white).font(.title3)
                    Text(item.description).foregroundColor(Color.white).font(.subheadline)
                }.background(Color(UIColor(hex: "212121")))
                Spacer()
                Text("x \(item.amount)").foregroundColor(Color.white)
                Spacer()
            }.background(Color(UIColor(hex: "212121")))
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
