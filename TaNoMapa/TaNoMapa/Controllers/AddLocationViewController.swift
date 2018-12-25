//
//  AddLocationViewController.swift
//  TaNoMapa
//
//  Created by Vitor Costa on 25/12/18.
//  Copyright © 2018 Vitor Costa. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: IBOutlets
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    // MARK: Override functions
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.delegate = self
        locationTextField.becomeFirstResponder()
        linkTextField.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // As we have only one segue on this view controller, we don't need to check the segue identifier
        let vc = segue.destination as! FindLocationViewController
        vc.link = linkTextField.text
        vc.location = locationTextField.text
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        // As we have only one segue on this view controller, we don't need to check the segue identifier
        return validateFields()
    }
    
    // MARK: IBActions
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Private function
    private func validateFields() -> Bool {
        if linkTextField.text!.isEmpty || locationTextField.text!.isEmpty {
            showAlert(title: "Attention", message: "Fields should not be empty")
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
