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
    
    func getPlayers(roomId: String, completionHandler: @escaping ([Player]) -> Void) {
        if let _ = Auth.auth().currentUser?.uid {
            var players: [Player] = []
            ref.child(roomId).child("players").observe(DataEventType.value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : AnyObject] ?? [:]
                players = []
                for (id, value) in postDict {
                    var player = Player()
                    player.id = id
                    if let playerRow = value as? [String : String] {
                        for (key, value) in playerRow {
                            if key == "captureState" {
                                player.captureState = value
                            }else if key == "playerLatitude" {
                                player.latitude = CLLocationDegrees(value)
                            }else if key == "playerLongitude" {
                                player.longitude = CLLocationDegrees(value)
                            }else if key == "playername" {
                                player.name = value
                            }else if key == "onlinestatus" {
                                player.onlineStatus = value
                            }else if key == "role" {
                                player.role = value
                            }
                        }
                    }
                    players.append(player)
                }
                completionHandler(players)
            })
        }
    }
    
    func getGameRule(roomId: String, completionHandler: @escaping ([String : String]) -> Void) {
        if let _ = Auth.auth().currentUser?.uid {
            var gamerule: [String : String] = [:]
            ref.child(roomId).child("gamerule").observe(.value, with: { (snapshot) in
                let postDict = snapshot.value as? [String : String] ?? [:]
                gamerule = [:]
                for (key, value) in postDict {
                    gamerule.updateValue(value, forKey: key)
                }
                completionHandler(gamerule)
            })
        }
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
    
    func updateRoomStatus(roomId: String, state: String) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["status": state]
            ref.child(roomId).child("status").updateChildValues(data)
        }
    }
    
    func updateGameStartTime(roomId: String, startTime: String) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["startTime": startTime]
            ref.child(roomId).updateChildValues(data)
        }
    }
    
    func updateGamerule(roomId: String, timelimit: Int, killerCaptureRange: Int, survivorPositionTransmissionInterval: Int, escapeTime: Int, hour: Int, minute: Int, escapeRange: Int, roomLatitude: String, roomLongitude: String) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["timelimit": String(timelimit + 1),
                        "killerCaptureRange": String(killerCaptureRange + 1),
                        "survivorPositionTransmissionInterval": String(survivorPositionTransmissionInterval + 1),
                        "escapeTime": String(escapeTime + 1),
                        "hour": String(hour),
                        "minute": String(minute + 1),
                        "escapeRange": String((escapeRange + 1) * 10),
                        "roomLatitude": roomLatitude,
                        "roomLongitude": roomLongitude]
            ref.child(roomId).child("gamerule").updateChildValues(data)
        }
    }
    
    func updatePlayerRole(roomId: String, playerId: String, role: String) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["role": role]
            ref.child(roomId).child("players").child(playerId).updateChildValues(data)
        }
    }
    
    func addPlayer(roomId: String, playerId: String, playerName: String, captureState: String, role: String) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["playername": playerName,
                        "onlinestatus": "online",
                        "captureState": captureState,
                        "role": role]
            ref.child(roomId).child("players").child(playerId).updateChildValues(data)
        }
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
    
    func updateCaptureState(roomId: String, playerId: String, state: String) {
        if let _ = Auth.auth().currentUser?.uid {
            let data = ["captureState": state]
            ref.child(roomId).child("players").child(playerId).updateChildValues(data)
        }
    }
    
}


