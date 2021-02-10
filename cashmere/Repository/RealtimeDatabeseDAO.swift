//
//  RealtimeDatabeseDAO.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/11.
//
import SwiftUI
import CoreLocation
import Firebase

class RealtimeDatabeseDAO: ObservableObject {
    @Published var ref = Database.database().reference()
    typealias CompGameRule = (_ rule:Rule?) -> Void
    typealias CompGetPlayers = ([Player]) -> Void
    
    func getPlayers(room: Room, completionHandler: @escaping CompGetPlayers)  {
        let roomId = room.id
        ref.child(roomId).child("players").observe(DataEventType.value, with: { (snapshot) in
            var players: [Player] = []
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for (id, value) in postDict {
                if let playerRow = value as? [String : String] {
                    let player = Player(src: playerRow)
                    // FIXME: palyerがnilの場合
                    players.append(player!)
                }
                // TODO: idだけ取得できる場合を考慮するべきか検討
            }
            completionHandler(players)
        })
    }
    
    func getGameRule(room: Room, completionHandler: @escaping CompGameRule) {
        let roomId = room.id
        ref.child(roomId).child("gamerule").observe(.value, with: { (snapshot) in
            // データを取り出し配列に格納しています
            if let value = snapshot.value as? [String:String] {
                let rule = Rule(src: value)
                // FIXME: ruleがnilの場合の制御
                completionHandler(rule!)
            }
        })
    }
    
    func gameStartCheck(roomId: String, completionHandler: @escaping (Bool) -> Void) {
        if let _ = Auth.auth().currentUser?.uid {
            ref.child(roomId).child("status").observe(DataEventType.value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : String] ?? [:]
                for (_, value) in postDict {
                    if value == "playing" {
                        completionHandler(true)
                    }
                }
            })
        }
    }
    
    func updateRoomStatus(roomId: String, state: Room.GameStatus) {
        let data = ["status": state.rawValue]
        ref.child(roomId).child("status").updateChildValues(data)
    }
    
    func updateGameStartTime(roomId: String, startTime: String) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["startTime": startTime]
            ref.child(roomId).updateChildValues(data)
        }
    }
    
    func updateGamerule(room:Room) {
        let roomId = room.id
        let data = room.rule.toDictionary()
        ref.child(roomId).child("gamerule").updateChildValues(data)
    }
    
    func updatePosition(room:Room) {
        let roomId = room.id
        // 位置情報がnilであってはいけない
        var data: [String:String] = [:]
        if let point = room.point {
            data = point.toDictionary()
        }
        
        ref.child(roomId).child("gamerule").updateChildValues(data)
    }
    
    func updatePlayerRole(roomId: String, playerId: String, role: Player.Role) {
        let data = ["role": role.rawValue]
        ref.child(roomId).child("players").child(playerId).updateChildValues(data)
    }
    
    func addPlayer(roomId:String, player:Player) {
        let data = player.toDictionary()
        let playerId = player.id
        ref.child(roomId).child("players").child(playerId).updateChildValues(data)
    }
    
    func deleteRoom(roomId: String) {
        if let _ = Auth.auth().currentUser?.uid {
            self.ref.child(roomId).removeValue()
        }
    }
    
    func addPlayerLocation(roomId: String, playerId: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["playerLatitude": String(latitude),
                        "playerLongitude": String(longitude)]
            ref.child(roomId).child("players").child(playerId).updateChildValues(data)
        }
    }
    
    func deletePlayer(roomId: String, playerId: String) {
        if let _ = Auth.auth().currentUser?.uid {
            ref.child(roomId).child("players").child(playerId).removeValue()
        }
    }
    
    func addCaptureFlag(roomId: String, playerId: String) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["captureState": "captured"]
            ref.child(roomId).child("players").child(playerId).updateChildValues(data)
        }
    }
    
    func updateCaptureState(roomId: String, playerId: String, state: Player.CaptureStatus) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["captureState": state]
            ref.child(roomId).child("players").child(playerId).updateChildValues(data)
        }
    }
    
}


