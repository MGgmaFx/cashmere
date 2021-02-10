//
//  ItemView.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/04.
//

import SwiftUI

struct ItemView: View {
    @EnvironmentObject var itemFlag: ItemFlag
    @EnvironmentObject var room: Room
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
    var body: some View {
        ZStack {
            Color(UIColor(hex: "212121")).edgesIgnoringSafeArea(.all)
            VStack {
                List {
                    ForEach(items, id: \.id) { item in
                        itemAlert(items: $items, showingAlert: $showingAlert, item: item)
                            .listRowBackground(Color(UIColor(hex: "212121")))
                    }
                }.onAppear {
                    // Listの背景色を変えるための処理
                    UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                    UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
                    UITableView.appearance().backgroundColor = UIColor.clear
                    UITableView.appearance().separatorStyle = .singleLine
                    UITableView.appearance().separatorColor = UIColor.white.withAlphaComponent(0.6)
                }
            }
        }
    }
}

struct itemAlert: View {
    @EnvironmentObject var itemFlag: ItemFlag
    @EnvironmentObject var RDDAO: RealtimeDatabeseDAO
    @EnvironmentObject var room: Room
    @Binding var items: [Item]
    @Binding var showingAlert: Bool
    let item: Item
    var body: some View {
        ZStack {
            Color(UIColor(hex: "212121")).edgesIgnoringSafeArea(.all)
            if item.amount > 0 && room.me.captureState != .captured {
                Button(action: {
                    showingAlert = true
                }) {
                    ItemListRow(item: item)
                        .listRowBackground(Color(UIColor(hex: "212121")))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(item.name),
                    message: Text(item.description),
                    primaryButton: .cancel(Text("キャンセル")),
                    secondaryButton: .default(Text("つかう")) {
                        if item.id == 1{
                            itemFlag.useStealthCloak = true
                            RDDAO.updateCaptureState(roomId: room.id, playerId: room.me.id, state: .hiding)
                            DispatchQueue.main.asyncAfter(deadline: .now() + Double(room.rule.survivorPositionTransmissionInterval * 60)) {
                                RDDAO.updateCaptureState(roomId: room.id, playerId: room.me.id, state: .escaping)
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
                        items[item.id - 1].amount = items[item.id - 1].amount - 1
                    })
                }
            } else {
                Button(action: {
                    showingAlert = true
                }) {
                    ItemListRow(item: item)
                        .listRowBackground(Color(UIColor(hex: "212121")))
                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(item.name),
                    message: Text(item.description),
                    dismissButton: .default(Text("もどる")))
                }
            }
        }
    }
}

