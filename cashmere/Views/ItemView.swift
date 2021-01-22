//
//  ItemView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct ItemView: View {
    @State var showingAlert = false
    @State var items: [Item] = [
            Item(id: 1,
               name: "ステルスマント",
               imageName: "questionmark.diamond",
               description: "１分間、使用者の位置情報を隠蔽する。",
               amount: 3),
            Item(id: 2,
               name: "黄金の豆",
               imageName: "questionmark.diamond",
               description: "１分間、鬼が逃走者を捕まえることができなくなる。",
               amount: 1),
            Item(id: 3,
               name: "サーチライト",
               imageName: "questionmark.diamond",
               description: "１分間、鬼の位置情報を表示する。",
               amount: 0),
        ]
    var body: some View {

        List (items.indices) { index in
            itemAlert(showingAlert: $showingAlert, item: $items[index])
        }

    }
}

struct itemAlert: View {
    @Binding var showingAlert: Bool
    @Binding var item: Item
    var body: some View {
        if item.amount > 0 {
            Button(action: {
                showingAlert = true
            }) {
                ItemListRow(item: item)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(item.name),
                message: Text(item.description),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .default(Text("つかう")) {
                    item.amount = item.amount - 1
                })
            }
        } else {
            Button(action: {
                showingAlert = true
            }) {
                ItemListRow(item: item)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(item.name),
                message: Text(item.description),
                dismissButton: .default(Text("もどる")))
            }
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
