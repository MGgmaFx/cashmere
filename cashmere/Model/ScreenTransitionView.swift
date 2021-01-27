//
//  ScreenTransitionView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/03.
//

import SwiftUI

class Model: ObservableObject {
    @Published var createRoomViewPushed = false
    @Published var joinRoomViewPushed = false
    @Published var isPresentedQRCodeView = false
    @Published var playerInvitePushed = false
    @Published var profileSettingsViewPushed = false
    @Published var isShowingScanner = false
    @Published var loginViewPushed = false
}
