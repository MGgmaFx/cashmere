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
                    for (_, player) in players {
                        playerList.append(player)
                    }
                }
            }
            completionHandler(playerList)
        })
    }
    
    func updateRoomStatus(roomId: String, state: String) {
        let data = ["status": state]
        ref.child(roomId).updateChildValues(data)
    }
    
    func updateRoomTimelimit(roomId: String, timelimit: Int) {
        let data = ["timelimit": String(timelimit)]
        ref.child(roomId).updateChildValues(data)
    }
    
    func addPlayer(roomId: String, playerId: String, playerName: String) {
        ref.child(roomId).child("players").child(playerId).setValue(["playername": playerName])
    }
    
    func deleteRoom(roomId: String) {
        self.ref.child(roomId).removeValue()
    }
    
    func addPlayerLocation(roomId: String, playerId: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        ref.child(roomId).child("players").child(playerId).setValue(["playerLatitude": latitude])
        ref.child(roomId).child("players").child(playerId).setValue(["playerLongitude": longitude])
    }
    
}
