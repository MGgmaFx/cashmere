//
//  ItemView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var model: Model
    var body: some View {
        List {
            ItemListRow()
            ItemListRow()
            ItemListRow()
            ItemListRow()
            ItemListRow()
        }
    }
}

struct ItemView_Previews: PreviewProvider {
    static var previews: some View {
        ItemView()
    }
}
