//
//  ContentView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/01.
//

import SwiftUI
import Firebase

struct ContentView: View {
    @State var isPresent = false
    var body: some View {
        GameView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
