//
//  SiginViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/2.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: AppLabel!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordLabel: AppLabel!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    
    @IBOutlet weak var confirmPasswordLabel: AppLabel!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    
    @IBOutlet weak var nameLabel: AppLabel!
    @IBOutlet weak var nametTextField: UITextField!
    
    @IBOutlet weak var phoneLabel: AppLabel!
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var countryLabel: AppLabel!
    @IBOutlet weak var countryTextField: UITextField!
    
    @IBOutlet weak var termsPrivacySwitch: UISwitch!
    @IBOutlet weak var termsPrivacyLabel: AppLabel!
    
    @IBOutlet weak var registerButton: PrimaryButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L10n.registerTitle
        setupUI()
    }
    
    private func setupUI() {
        emailLabel.style = .body
        passwordLabel.style = .body
        confirmPasswordLabel.style = .body
        nameLabel.style = .body
        phoneLabel.style = .body
        countryLabel.style = .body
        termsPrivacyLabel.style = .secondary
        
        emailLabel.text = L10n.emailTitle
        passwordLabel.text = L10n.passwordTitle
        confirmPasswordLabel.text = L10n.confirmPasswordPlaceholder
        nameLabel.text = L10n.nameTitle
        phoneLabel.text = L10n.phoneTitle
        countryLabel.text = L10n.countryTitle
        
        emailTextField.placeholder = L10n.emailPlaceholder
        passwordTextField.placeholder = L10n.passwordPlaceholder
        confirmPasswordTextField.placeholder = L10n.confirmPasswordPlaceholder
        nametTextField.placeholder = L10n.namePlaceholder
        phoneTextField.placeholder = L10n.optionPlaceholder
        countryTextField.placeholder = L10n.optionPlaceholder
        
        passwordTextField.enablePasswordToggle()
        confirmPasswordTextField.enablePasswordToggle()
        
        registerButton.setTitle(L10n.registerTitle, for: .normal)
 
    }

}
