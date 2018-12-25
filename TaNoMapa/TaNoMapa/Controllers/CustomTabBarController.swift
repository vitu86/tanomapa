//
//  CustomTabBarController
//  TaNoMapa
//
//  Created by Vitor Costa on 06/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit

class CustomTabBarController: UITabBarController {
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        buildNavigation()
        NotificationCenter.default.addObserver(self, selector: #selector(loadData), name: Notification.Name.locationsLoaded, object: nil)
        loadData(notification: nil)
    }
    
    // MARK: Private functions
    private func buildNavigation() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonTapped))
        let refreshButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: self, action: #selector(refreshButtonTapped))
        navigationItem.rightBarButtonItems = [addButton, refreshButton]        
        
        let logoutButton = UIBarButtonItem(title: "LOGOUT", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonTapped))
        navigationItem.leftBarButtonItem = logoutButton
    }
    
    @objc private func addButtonTapped(_ sender:UIBarButtonItem) {
        performSegue(withIdentifier: "segueToAdd", sender: nil)
    }
    
    @objc private func refreshButtonTapped(_ sender:UIBarButtonItem) {
        loadData(notification: nil)
    }
    
    @objc private func logoutButtonTapped(_ sender:UIBarButtonItem) {
        showCenterIndicator()
        NetworkHelper.sharedInstance.logout { (result) in
            self.hideCenterIndicator()
            switch result {
            case .Success:
                self.dismiss(animated: true, completion: nil)
            case .NoInternet:
                self.showAlert(title: "Attention", message: "You are offline.")
            case .Fail:
                self.showAlert(title: "Attention", message: "Could not logout.")
            }
        }
    }
    
    @objc private func loadData(notification:Notification?) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NotificationCenter.default.post(name: NSNotification.Name.loadingLocations, object: nil)
        NetworkHelper.sharedInstance.loadLocations { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .Success:
                NotificationCenter.default.post(name: NSNotification.Name.locationsLoaded, object: nil)
            case .NoInternet:
                self.showAlert(title: "Attention", message: "You are offline.")
            case .Fail:
                self.showAlert(title: "Attention", message: "Could not load data.")
            }
        }
    }
}
