//
//  ItemView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct ItemView: View {
    var body: some View {
        let items: [Item] = [
                Item(id: 1,
                   name: "ステルスマント",
                   imageName: "questionmark.diamond",
                   description: "１分間、使用者の位置情報を隠蔽する。",
                   amount: 0),
                Item(id: 2,
                   name: "黄金の豆",
                   imageName: "questionmark.diamond",
                   description: "１分間、鬼が逃走者を捕まえることができなくなる。",
                   amount: 0),
                Item(id: 3,
                   name: "サーチライト",
                   imageName: "questionmark.diamond",
                   description: "１分間、鬼の位置情報を表示する。",
                   amount: 0),
            ]
        List (items) { item in
            ItemListRow(item: item)
        }

    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
