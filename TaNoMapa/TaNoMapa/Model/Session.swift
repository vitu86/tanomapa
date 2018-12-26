//
//  Session.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 06/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation

struct PostSession: Codable {
    let account: Account?
    let session: Session?
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct UserData: Codable {
    let firstName: String?
    let lastName: String?
    
    enum CodingKeys: String, CodingKey
    {
        case firstName = "first_name"
        case lastName = "last_name"
    }
}
