//
//  NotificationExtensions.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 06/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let loadingLocations = Notification.Name("loadingLocations")
    static let locationsLoaded = Notification.Name("locationsLoaded")
    static let shouldReloadLocations = Notification.Name("shouldReloadLocations")
}
