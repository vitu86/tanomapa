//
//  UITextFieldExtensions.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 05/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    // Add show/hide icon to password textfield
    func addTogglePassword() {
        let toggle  = UIButton(type: .custom)
        toggle.setImage(#imageLiteral(resourceName: "PasswordShow").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .normal)
        toggle.setImage(#imageLiteral(resourceName: "PasswordHide").withRenderingMode(UIImage.RenderingMode.alwaysTemplate), for: .selected)
        toggle.tintColor = UIColor.black.withAlphaComponent(0.54)
        toggle.frame = CGRect(x: 0, y: 0, width: 28, height: 24)
        toggle.addTarget(self, action: #selector(showHidePass), for: .touchUpInside)
        toggle.imageEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 2)
        self.rightViewMode = .always
        self.rightView = toggle
        self.isSecureTextEntry = true
    }
    
    // Toggle icon and security of password textfield
    @objc func showHidePass(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !self.isSecureTextEntry
    }
}
