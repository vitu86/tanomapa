//
//  ViewController.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 05/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
    }
    
    // MARK: IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
    }
    
    @IBAction func signupButtonTapped(_ sender: Any) {
        if let url = URL(string: "https://auth.udacity.com/sign-up"){
            UIApplication.shared.open(url, options: [:]) { (_) in }
        }
    }
    
    // MARK: Private functions
    private func initUI() {
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // MARK: UITextFieldDelegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
