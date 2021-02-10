//
//  JoinRoomView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI
import CodeScanner
import Firebase

struct JoinRoomView: View {
    @EnvironmentObject var model: Model
    @EnvironmentObject var gameEventFlag: GameEventFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @EnvironmentObject var room: Room
    var body: some View {
        VStack {
            
            Spacer()
            if gameEventFlag.isGameWating {
                GameWatingView()
            } else {
                Image("rule")
                    .resizable()
                    .frame(width: 280, height: 400, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            }
            Spacer()
            
            if !(gameEventFlag.isGameWating) {
                Button(action: {
                    model.isShowingScanner = true
                }) {
                    Text("ルームに参加する")
                }
                .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "F2910A"))))
                .sheet(isPresented: $model.isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
                }
            }
            
            Button(action: {
                self.model.joinRoomViewPushed = false
                leaveRoom(room: room)
                
            }) {
                Text("もどる").foregroundColor(Color.black)
            }
            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "C9E8F1"))))
            .navigationBarHidden(true)
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isEscaping) {
                EscapeTimeView(startDate: Calendar.current.date(byAdding: .second, value: room.rule.escapeTime * 60, to: Date())!)
            })
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isGameStarted) {
                GameView()
            })
        }.frame(minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity
        ).background(Color(UIColor(hex: "212121"))).edgesIgnoringSafeArea(.all)
        .onAppear {
            joinRoom()
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        model.isShowingScanner = false
        switch result {
        case .success(let code):
            room.id = code
            RDDAO.addPlayer(roomId: room.id, player: room.me)
            RDDAO.getPosition(roomId: room.id) { position in
                room.point = position
            }
            RDDAO.getGameRule(room: room) { rule in
                if let r = rule {
                    self.room.rule = r
                }
                // FIXME: nilの場合は何もしない
            }
            RDDAO.getPlayers(room: room){ (players) in
                room.players = players
                for player in players {
                    if room.me.id == player.id {
                        room.me.latitude = player.latitude
                        room.me.longitude = player.longitude
                        room.me.captureState = player.captureState
                        room.me.onlineStatus = player.onlineStatus
                        if room.me.captureState.rawValue == "captured" {
                            gameEventFlag.isCaptured = true
                        }
                    }
                }
                if gameEventFlag.isGameStarted {
                    checkAllCaught(plyers: room.players){ (isAllCaught) in
                        if isAllCaught {
                            gameEventFlag.isGameOver = isAllCaught
                        }
                    }
                }
            }
            RDDAO.gameStartCheck(roomId: room.id){ isEscaping in
                gameEventFlag.isEscaping = isEscaping
                DispatchQueue.main.asyncAfter(deadline: .now() + Double(room.rule.escapeTime) * 60) {
                    gameEventFlag.isEscaping = false
                    gameEventFlag.isGameStarted = true
                }
            }
            gameEventFlag.isGameWating = true
            
            
        case .failure(let error):
            print("Scanning failed")
            print(error)
        }
    }
    
    private func joinRoom() {
        room.me.role = .survivor
        room.me.captureState = .escaping
    }
    
    private func leaveRoom(room: Room) {
        gameEventFlag.isGameWating = false
        if room.id != "" {
            RDDAO.deletePlayer(roomId: room.id, playerId: room.me.id)
        }
    }
    private func checkAllCaught(plyers: [Player], completionHandler: @escaping (Bool) -> Void) {
        var isAllCaught = true
        for player in room.players {
            if player.captureState != .captured && player.role == .survivor {
                isAllCaught = false
            }
        }
        completionHandler(isAllCaught)
    }
}
