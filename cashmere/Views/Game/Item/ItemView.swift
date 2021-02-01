//
//  ItemView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var itemFlag: ItemFlag
    @State var showingAlert = false
    @State var items: [Item] = [
            Item(id: 1,
               name: "ステルスマント",
               imageName: "questionmark.diamond",
               description: "次回の位置情報送信時、使用者の位置情報を隠蔽する。",
               amount: 3),
            Item(id: 2,
               name: "黄金の豆",
               imageName: "questionmark.diamond",
               description: "１分間、鬼が逃走者を捕まえることができなくなる。",
               amount: 3),
            Item(id: 3,
               name: "サーチライト",
               imageName: "questionmark.diamond",
               description: "１分間、鬼の位置情報を表示する。",
               amount: 3),
        ]
    @Binding var gamerule: [String : String]
    @Binding var roomId: String
    @Binding var player: Player
    var body: some View {

        List (items.indices) { index in
            itemAlert(roomId: $roomId, gamerule: $gamerule, showingAlert: $showingAlert, item: $items[index], player: $player)
        }
    }
}

struct itemAlert: View {
    @EnvironmentObject var itemFlag: ItemFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @Binding var roomId: String
    @Binding var gamerule: [String : String]
    @Binding var showingAlert: Bool
    @Binding var item: Item
    @Binding var player: Player
    var body: some View {
        if item.amount > 0 && player.captureState != "captured"{
            Button(action: {
                showingAlert = true
            }) {
                ItemListRow(item: item)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(item.name),
                message: Text(item.description),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .default(Text("つかう")) {
                    if item.id == 1{
                        itemFlag.useStealthCloak = true
                        RDDAO.updateCaptureState(roomId: roomId, playerId: player.id, state: "hiding")
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(gamerule["survivorPositionTransmissionInterval"] ?? "1")! * 60) {
                            RDDAO.updateCaptureState(roomId: roomId, playerId: player.id, state: "escaping")
                            itemFlag.useStealthCloak = false
                        }
                    } else if item.id == 2 {
                        itemFlag.useGoldenBeans = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(60)) {
                            itemFlag.useGoldenBeans = false
                        }
                    } else if item.id == 3 {
                        itemFlag.useSearchlight = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + Double(60)) {
                            itemFlag.useSearchlight = false
                        }
                    }
                    item.amount = item.amount - 1
                })
            }
        } else {
            Button(action: {
                showingAlert = true
            }) {
                ItemListRow(item: item)
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(item.name),
                message: Text(item.description),
                dismissButton: .default(Text("もどる")))
            }
        }
    }
}

