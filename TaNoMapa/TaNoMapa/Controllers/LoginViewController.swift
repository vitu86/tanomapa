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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        emailTextField.becomeFirstResponder()
    }
    
    // MARK: IBActions
    @IBAction func loginButtonTapped(_ sender: Any) {
        self.view.endEditing(true)
        if validateFields() {
            showCenterIndicator()
            NetworkHelper.sharedInstance.login(email: emailTextField.text!, password: passwordTextField.text!) { (result) in
                self.hideCenterIndicator()
                switch result {
                case .Success:
                    self.emailTextField.text = ""
                    self.passwordTextField.text = ""
                    self.performSegue(withIdentifier: "segueToLocations", sender: nil)
                case .NoInternet:
                    self.showAlert(title: "Attention", message: "You are offline.")
                case .Fail:
                    self.showAlert(title: "Attention", message: "Invalid email or password.")
                }
            }
        }
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
        passwordTextField.addTogglePassword()
    }
    
    private func validateFields() -> Bool {
        if emailTextField.text!.isEmpty || passwordTextField.text!.isEmpty {
            self.showAlert(title: "Attention", message: "Fields should not be empty!")
            return false
        }
        return true
    }
    
    // MARK: UITextFieldDelegate functions
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
