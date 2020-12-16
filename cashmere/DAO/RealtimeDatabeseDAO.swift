//
//  RealtimeDatabeseDAO.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/11.
//
import CoreLocation
import Firebase

struct RealtimeDatabeseDAO {
    var ref = Database.database().reference()
    
    func getPlayerNameList(roomId: String, completionHandler: @escaping ([String]) -> Void) {
        var playerList: [String] = []
        ref.child(roomId).child("players").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            playerList = []
            for (_, value) in postDict {
                if let players = value as? [String : String] {
                    for (key, player) in players {
                        if key == "playername" {
                            playerList.append(player)
                        }
                    }
                }
            }
            completionHandler(playerList)
        })
    }
    
    func getPlayers(roomId: String, completionHandler: @escaping ([Player]) -> Void) {
        var players: [Player] = []
        ref.child(roomId).child("players").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            players = []
            for (uuid, value) in postDict {
                var temp = Player()
                temp.id = uuid
                if let player = value as? [String : String] {
                    for (key, value) in player {
                        if key == "playerLatitude" {
                            temp.latitude = CLLocationDegrees(value)
                        }
                        if key == "playerLongitude" {
                            temp.longitude = CLLocationDegrees(value)
                        }
                        if key == "playername" {
                            temp.name = value
                        }
                    }
                }
                players.append(temp)
            }
            completionHandler(players)
        })
    }
    
    func getGameRule(roomId: String, completionHandler: @escaping ([String : String]) -> Void) {
        var gamerule: [String : String] = [:]
        ref.child(roomId).child("gamerule").observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : String] ?? [:]
            gamerule = [:]
            for (key, value) in postDict {
                gamerule.updateValue(value, forKey: key)
            }
            print(gamerule)
            completionHandler(gamerule)
        })
    }
    
    func gameStartCheck(roomId: String, completionHandler: @escaping (Bool) -> Void) {
        ref.child(roomId).observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String : AnyObject] ?? [:]
            for (_, value) in postDict {
                var state = ""
                state = value as? String ?? ""
                if state == "playing" {
                    completionHandler(true)
                }
            }
        })
    }
    
    func updateRoomStatus(roomId: String, state: String) {
        let data = ["status": state]
        ref.child(roomId).updateChildValues(data)
    }
    
    func updateGameStartTime(roomId: String, startTime: String) {
        let data = ["startTime": startTime]
        ref.child(roomId).updateChildValues(data)
    }
    
    func updateGamerule(roomId: String, timelimit: Int, demonCaptureRange: Int, survivorPositionTransmissionInterval: Int) {
        let data = ["timelimit": String(timelimit),
                    "demonCaptureRange": String(demonCaptureRange),
                    "survivorPositionTransmissionInterval": String(survivorPositionTransmissionInterval)]
        ref.child(roomId).child("gamerule").updateChildValues(data)
    }
    
    func addPlayer(roomId: String, playerId: String, playerName: String) {
        let data = ["playername": playerName,
                    "onlinestatus": "online"]
        ref.child(roomId).child("players").child(playerId).updateChildValues(data)
    }
    
    func deleteRoom(roomId: String) {
        self.ref.child(roomId).removeValue()
    }
    
    func addPlayerLocation(roomId: String, playerId: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let data = ["playerLatitude": String(latitude),
                    "playerLongitude": String(longitude)]
        ref.child(roomId).child("players").child(playerId).updateChildValues(data)
    }
    
}
