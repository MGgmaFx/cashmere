//
//  ScreenTransitionView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/02.
//

import SwiftUI

class Model: ObservableObject {
    @Published var mainMenuViewPushed = false
    @Published var createRoomViewPushed = false
    @Published var gameViewPushed = false
}
