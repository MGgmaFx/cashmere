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
    @Binding var player: Player
    @State private var isShowingScanner = false
    @State var roomId: String = ""
    @State var isGameStarted = false
    @State var time = 60
    var ref = Database.database().reference()
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
                .frame(width: 240, height: 60, alignment: .center)
            }
            .background(Color.blue)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
            .fullScreenCover(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
            }
            
            Button(action: {
                self.model.joinRoomViewPushed = false
            }) {
                Text("もどる")
                .frame(width: 240, height: 60, alignment: .center)
            }
            .background(Color.gray)
            .cornerRadius(20)
            .foregroundColor(Color.white)
            .padding()
            .navigationBarHidden(true)
            
            VStack {
                
            }
            .background(EmptyView().fullScreenCover(isPresented: $isGameStarted) {
                GameView(time: $time, roomId: $roomId)
            })
            
        }
        
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            roomId = code
            let data = ["playername": player.name]
            ref.child(roomId).child("players").child(player.id).updateChildValues(data)
            ref.child(roomId).observe(DataEventType.value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                for (_, value) in postDict {
                    var state = ""
                    state = value as? String ?? ""
                    if state == "playing" {
                        isGameStarted = true
                    }
                }
            })
            model.isGameWating = true
            
            
        case .failure(let error):
            print("Scanning failed")
            print(error)
        }
    }
}
