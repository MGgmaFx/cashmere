//
//  ResultView.swift
//  cashmere
//
//  Created by 志村豪気 on 2021/01/19.
//

import SwiftUI

struct ResultView: View {
    @EnvironmentObject var gameEventFlag: GameEventFlag
    @EnvironmentObject var model: Model
    @EnvironmentObject var room: Room
    @State var isSurviverWin = false
    var body: some View {
        
        VStack {
            if isSurviverWin {
                if room.me.role == .survivor {
                    Image("app_logo_win").resizable().frame(width: 250, height: 130)
                    Image("survivor_win")
                } else {
                    Image("app_logo_lose").resizable().frame(width: 250, height: 130)
                    Image("killer_lose")
                }
            } else {
                if room.me.role == .survivor {
                    Image("app_logo_lose").resizable().frame(width: 250, height: 130)
                    Image("survivor_lose")
                } else {
                    Image("app_logo_win").resizable().frame(width: 250, height: 130)
                    Image("killer_win")
                }
            }
            
            Button(action: {
                gameInitialization()
            }) {
                Text("メニューにもどる")
            }.buttonStyle(CustomButtomStyle(color: Color.orange))
        }.onAppear {
            if gameEventFlag.isTimeOut {
                isSurviverWin = true
            } else {
            }
        }
    }
    func gameInitialization() -> Void {
        // 上位のビューから順番に閉じないと下位のビューがうまく閉じられないので上位ビューから順次閉じている
        DispatchQueue.main.async {
            gameEventFlag.isGameOver = false
            gameEventFlag.isTimeOut = false
            gameEventFlag.isCaptured = false
            DispatchQueue.main.async {
                gameEventFlag.isEscaping = false
                gameEventFlag.isGameWating = false
                model.isPresentedQRCodeView = false
                model.profileSettingsViewPushed = false
                model.isShowingScanner = false
                model.loginViewPushed = false
                DispatchQueue.main.async {
                    gameEventFlag.isGameStarted = false
                    DispatchQueue.main.async {
                        model.playerInvitePushed = false
                        model.joinRoomViewPushed = false
                        model.createRoomViewPushed = false
                    }
                }
            }
        }
    }
}

