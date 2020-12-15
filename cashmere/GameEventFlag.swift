//
//  GameEventFlag.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/14.
//

import SwiftUI

class GameEventFlag: ObservableObject {
    @Published var isGameOver = false
    @Published var isGameStarted = false
}
