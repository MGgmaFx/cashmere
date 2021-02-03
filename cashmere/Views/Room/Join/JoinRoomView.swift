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
    @State var roomId: String = ""
    @State var players: [Player] = []
    @State var gamerule: [String: String] = [:]
    @State var escapingTime: String = "99"
    @Binding var player: Player
    var time = 0
    var body: some View {
        VStack {
            
            Spacer()
            if gameEventFlag.isGameWating {
                GameWatingView(roomId: $roomId, players: $players, gamerule: $gamerule)
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
                leaveRoom(roomId: roomId)
                roomId = ""
                
            }) {
                Text("もどる")
            }
            .buttonStyle(CustomButtomStyle(color: Color(UIColor(hex: "C9E8F1"))))
            .navigationBarHidden(true)
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isEscaping) {
                EscapeTimeView(setDate: Calendar.current.date(byAdding: .second, value: (Int(gamerule["escapeTime"] ?? "99")! * 60), to: Date())!)
            })
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $gameEventFlag.isGameStarted) {
                GameView(players: $players, roomId: $roomId, player: $player, gamerule: $gamerule, time: Int(gamerule["timelimit"] ?? "99")! - 1)
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
            roomId = code
            RDDAO.getPlayers(roomId: roomId){ (result) in
                players = result
                players.sort { $0.id < $1.id }
                for playerDB in players {
                    if player.id == playerDB.id {
                        player.latitude = playerDB.latitude
                        player.longitude = playerDB.longitude
                        player.captureState = playerDB.captureState
                        player.onlineStatus = playerDB.onlineStatus
                        player.role = playerDB.role
                        if player.captureState == "captured" {
                            gameEventFlag.isCaptured = true
                        }
                    }}
            }
            
            RDDAO.addPlayer(roomId: roomId, playerId: player.id, playerName: player.name, captureState: player.captureState ?? "escaping", role: player.role ?? "survivor")
            RDDAO.updatePlayerRole(roomId: roomId, playerId: player.id, role: "survivor")
            RDDAO.gameStartCheck(roomId: roomId){ result in
                gameEventFlag.isEscaping = result
                DispatchQueue.main.asyncAfter(deadline: .now() + Double((Int(gamerule["escapeTime"] ?? "99")! * 60))) {
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
        player.role = "survivor"
        player.captureState = "escaping"
    }
    
    private func leaveRoom(roomId: String) {
        gameEventFlag.isGameWating = false
        players = []
        gamerule = [:]
        player.role = ""
        player.captureState = ""
        if roomId != "" {
            RDDAO.deletePlayer(roomId: roomId, playerId: player.id)
        }
    }
}
