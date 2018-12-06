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
        loadData()
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
        print("Clicou no add")
    }
    
    @objc private func refreshButtonTapped(_ sender:UIBarButtonItem) {
        print("Clicou no refresh")
        loadData()
    }
    
    @objc private func logoutButtonTapped(_ sender:UIBarButtonItem) {
        showCenterIndicator()
        NetworkHelper.sharedInstance.logout { (result) in
            self.hideCenterIndicator()
            switch result {
            case .Success:
                self.dismiss(animated: true, completion: nil)
            case .NoInternet:
                self.showAlert(title: "Atenção", message: "Conecte-se à internet e tente novamente.")
            case .Fail:
                self.showAlert(title: "Atenção", message: "Ocorreu um erro durante o logout.")
            }
        }
    }
    
    private func loadData() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NotificationCenter.default.post(name: NSNotification.Name.loadingLocations, object: nil)
        NetworkHelper.sharedInstance.loadLocations { (result) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch result {
            case .Success:
                NotificationCenter.default.post(name: NSNotification.Name.locationsLoaded, object: nil)
            case .NoInternet:
                self.showAlert(title: "Atenção", message: "Conecte-se à internet e pressione o botão de atualizar.")
            case .Fail:
                self.showAlert(title: "Atenção", message: "Ocorreu um erro durante o download dos dados.")
            }
        }
    }
}
