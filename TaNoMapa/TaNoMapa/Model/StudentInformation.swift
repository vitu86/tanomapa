//
//  Location.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 06/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation

struct StudentInformation {
    var createdAt:String?
    var firstName:String?
    var lastName:String?
    var latitude:Double?
    var longitude:Double?
    var mapString:String?
    var mediaURL:String?
    var objectId:String?
    var uniqueKey:String?
    var updatedAt:String?
    
    init?(json: [String: Any]) {
        
        guard let createdAt = json["createdAt"] as? String,
            let firstName = json["firstName"] as? String,
            let lastName = json["lastName"] as? String,
            let latitude = json["latitude"] as? Double,
            let longitude = json["longitude"] as? Double,
            let mapString = json["mapString"] as? String,
            let mediaURL = json["mediaURL"] as? String,
            let objectId = json["objectId"] as? String,
            let uniqueKey = json["uniqueKey"] as? String,
            let updatedAt = json["updatedAt"] as? String
            else {
                return nil
        }
        
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }
}

struct DataToServer {
    var firstName:String?
    var lastName:String?
    var mapString:String?
    var mediaURL:String?
    var latitude:String?
    var longitude:String?
}
