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
    var ref = Database.database().reference()
    var body: some View {
        VStack {
            Spacer()
            Text("JoinRoom View").font(.title)
            Spacer()
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
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], completion: self.handleScan)
            }
        }
        .navigationBarHidden(true)
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        self.isShowingScanner = false
        switch result {
        case .success(let code):
            let data = ["playername": player.name]
            self.ref.child(code).child("players").child(player.id).updateChildValues(data)
            print(code)
        case .failure(let error):
            print("Scanning failed")
            print(error)
        }
    }
}
