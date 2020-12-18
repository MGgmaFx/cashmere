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
    @EnvironmentObject var eventFlag: GameEventFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @State var roomId: String = ""
    @State var players: [Player] = []
    @State var gamerule: [String: String] = [:]
    @State var escapingTime: String = "46"
    @Binding var player: Player
    var time = 0
    var body: some View {
        VStack {
            Spacer()
            Text("JoinRoom View").font(.title)
            Spacer()
            if eventFlag.isGameWating {
                GameWatingView(roomId: $roomId, players: $players, gamerule: $gamerule)
            }
            Spacer()
            
            
            if !(eventFlag.isGameWating) {
                Button(action: {
                    model.isShowingScanner = true
                }) {
                    Text("ルームに参加する")
                }
                .buttonStyle(CustomButtomStyle(color: Color.green))
                .sheet(isPresented: $model.isShowingScanner) {
                    CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
                }
            }
            
            Button(action: {
                self.model.joinRoomViewPushed = false
                leaveLoom(roomId: roomId)
                eventFlag.isGameWating = false
                players = []
                gamerule = [:]
                roomId = ""
            }) {
                Text("もどる")
            }
            .buttonStyle(CustomButtomStyle(color: Color.gray))
            .navigationBarHidden(true)
            
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $eventFlag.isGameStarted) {
                GameView(players: $players, roomId: $roomId, player: $player, gamerule: $gamerule, time: 60)
            })
            
            VStack {
                
            }
            .background(EmptyView().fullScreenCover(isPresented: $eventFlag.isEscaping) {
                EscapeTimeView(setDate: Calendar.current.date(byAdding: .second, value: (Int(gamerule["escapeTime"] ?? "46")! * 60 - 1), to: Date())!)
            })
            
        }.onAppear {
            
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        model.isShowingScanner = false
        switch result {
        case .success(let code):
            roomId = code
            RDDAO.addPlayer(roomId: roomId, playerId: player.id, playerName: player.name)
            RDDAO.updatePlayerRole(roomId: roomId, playerId: player.id, role: "survivor")
            RDDAO.gameStartCheck(roomId: roomId){ result in
                eventFlag.isEscaping = result
                DispatchQueue.main.asyncAfter(deadline: .now() + Double((Int(gamerule["escapeTime"] ?? "46")! * 60))) {
                    eventFlag.isEscaping = false
                    eventFlag.isGameStarted = true
                }
            }
            eventFlag.isGameWating = true
            
            
        case .failure(let error):
            print("Scanning failed")
            print(error)
        }
    }
    private func leaveLoom(roomId: String) {
        if roomId != "" {
            RDDAO.deletePlayer(roomId: roomId, playerId: player.id)
        }
    }
}
