//
//  UIViewControllerExtensions.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 05/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit
import MaterialComponents

extension UIViewController {
    
    typealias returnAlertFunction = (UIAlertAction) -> Void
    func showAlert(title:String, message:String, okFunction: returnAlertFunction? = nil, cancelFunction: returnAlertFunction? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let cancelFunction = cancelFunction {
            alert.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: cancelFunction))
        }
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: okFunction))
        self.present(alert, animated: true)
    }
    
    func showCenterIndicator() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        let activityIndicator = ActivityIndicator.shared
        activityIndicator.cycleColors = [UIColor.black]
        activityIndicator.strokeWidth = 4
        activityIndicator.radius = 24
        activityIndicator.startAnimating()
        self.view.addSubview(activityIndicator)
    }
    
    func hideCenterIndicator() {
        UIApplication.shared.endIgnoringInteractionEvents()
        let activityIndicator = ActivityIndicator.shared
        activityIndicator.stopAnimating()
    }
    
}

class ActivityIndicator: MDCActivityIndicator {
    static let shared = MDCActivityIndicator(frame: CGRect(x: UIScreen.main.bounds.width * 0.5 - 16, y:
        UIScreen.main.bounds.height * 0.5 - 16, width: 32, height: 32))
    private init() {
        super.init(frame: CGRect.init())
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
