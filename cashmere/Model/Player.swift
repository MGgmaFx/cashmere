//
//  User.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/08.
//

import SwiftUI
import CoreLocation

struct Player: Identifiable {
    enum CaptureStatus:String {
        case escaping = "逃走中"
        case tracking = "追跡中"
        case captured = "確保済"
        case hiding = "潜伏中"
    }
    
    enum Role:String {
        case killer = "鬼"
        case survivor = "逃走者"
    }
    
    enum CommunicationStatus:String {
        case online = "オンライン"
        case returning = "復帰中"
    }
    // これはなに？
    var uid: String?
    // ユーザID
    var id = UUID().uuidString
    // プレイヤー名
    var name: String = "プレイヤー"
    // 緯度(東京駅)
    var latitude: String = "35.681200"
    // 経度(東京駅)
    var longitude: String = "139.767336"
    // 通信状況
    var onlineStatus: CommunicationStatus = .online
    // 確保状態
    var captureState: CaptureStatus = .escaping
    // 役割
    var role: Role = .survivor
    // アイテム
    var items:[Item] = []
    
    init() {
        // なにもしない
    }
    
    //失敗可能イニシャライザ(DB不整合時)
    init?(src:[String:String]){
        self.id = src["id"]!
        self.name = src["playername"]!
        self.latitude = src["playerLatitude"]!
        self.longitude = src["playerLongitude"]!
        self.onlineStatus = Player.CommunicationStatus(rawValue: src["onlineStatus"]!)!
        self.captureState = Player.CaptureStatus(rawValue: src["captureState"]!)!
        self.role = Player.Role(rawValue: src["role"]!)!
    }
    
    func captureStateToDic() -> [String:String]{
        return ["captureState": captureState.rawValue]
    }
    
    func toDictionary() -> [String:String] {
        return [
                "id":id,
                "playername": name,
                "playerLatitude": latitude,
                "playerLongitude": longitude,
                "onlineStatus": onlineStatus.rawValue,
                "captureState": captureState.rawValue,
                "role": role.rawValue
        ]
    }
}
