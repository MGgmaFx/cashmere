//
//  User.swift
//  cashmere
//
//  Created by 志村豪気 on 2020/12/08.
//

import SwiftUI
import CoreLocation

struct Player {
    var id = UUID().uuidString
    var name: String = "プレイヤー"
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
}
