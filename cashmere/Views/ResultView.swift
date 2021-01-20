//
//  ResultView.swift
//  cashmere
//
//  Created by 志村豪気 on 2021/01/19.
//

import SwiftUI

struct ResultView: View {
    @Binding var players: [Player]
    @EnvironmentObject var gameFlag: GameEventFlag
    @EnvironmentObject var model: Model
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        var isSurviverWin = false
        VStack {
            if isSurviverWin {
                Text("生存者の勝ち")
            } else {
                Text("鬼の勝ち")
            }
            
            Button(action: {
                gameInitialization()
            }) {
                Text("メニューにもどる")
            }.buttonStyle(CustomButtomStyle(color: Color.orange))
        }.onAppear {
            if gameFlag.isTimeOut {
                isSurviverWin = true
            }
        }
    }
    func gameInitialization() -> Void {
        gameFlag.isGameOver = false
        gameFlag.isEscaping = false
        gameFlag.isGameWating = false
        gameFlag.isTimeOut = false
        gameFlag.isGameStarted = false
        model.playerInvitePushed = false
        model.createRoomViewPushed = false
        model.joinRoomViewPushed = false
        model.isPresentedQRCodeView = false
        model.profileSettingsViewPushed = false
        model.isShowingScanner = false
        model.loginViewPushed = false
    }
}
