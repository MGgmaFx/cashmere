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
    @State var isSurviverWin = false
    var body: some View {
        
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
            } else {
            }
        }
    }
    func gameInitialization() -> Void {
        
        
        
        DispatchQueue.main.async {
            model.createRoomViewPushed = false
            DispatchQueue.main.async {
                gameFlag.isEscaping = false
                gameFlag.isGameWating = false
                model.joinRoomViewPushed = false
                model.isPresentedQRCodeView = false
                model.profileSettingsViewPushed = false
                model.isShowingScanner = false
                model.loginViewPushed = false
                gameFlag.isTimeOut = false
                model.playerInvitePushed = false
                DispatchQueue.main.async {
                    gameFlag.isGameOver = false
                    DispatchQueue.main.async {
                        gameFlag.isGameStarted = false
                    }
                }
            }
        }
        
    }
}
