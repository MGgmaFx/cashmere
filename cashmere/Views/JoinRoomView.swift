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
    @Binding var player: Player
    @State private var isShowingScanner = false
    @State var roomId: String = ""
    @State var time = 60
    var RDDAO = RealtimeDatabeseDAO()
    var body: some View {
        VStack {
            Spacer()
            Text("JoinRoom View").font(.title)
            Spacer()
            if model.isGameWating {
                GameWatingView(roomId: $roomId)
            }
            Spacer()
            
            Button(action: {
                isShowingScanner = true
            }) {
                Text("ルームに参加する")
            }
            .buttonStyle(CustomButtomStyle(color: Color.green))
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
            }
            
            Button(action: {
                self.model.joinRoomViewPushed = false
            }) {
                Text("もどる")
            }
            .buttonStyle(CustomButtomStyle(color: Color.gray))
            .navigationBarHidden(true)
            
            
            VStack {
            }
            .background(EmptyView().fullScreenCover(isPresented: $eventFlag.isGameStarted) {
                GameView(time: $time, roomId: $roomId, player: $player)
            })
            
        }
        
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            roomId = code
            RDDAO.addPlayer(roomId: roomId, playerId: player.id, playerName: player.name)
            RDDAO.gameStartCheck(roomId: roomId){ result in
                eventFlag.isGameStarted = result
            }
            model.isGameWating = true
            
            
        case .failure(let error):
            print("Scanning failed")
            print(error)
        }
    }
}
