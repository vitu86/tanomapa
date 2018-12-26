//
//  DataSingleton.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 25/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation

class DataSingleton {
    
    // MARK: STATIC OBJECT REFERENCE
    static let sharedInstance:DataSingleton = DataSingleton()
    
    // MARK: Public properties
    var session:PostSession!
    var locations:[StudentInformation] = []
    
    // private init for override purpose
    private init() {
    }
}
