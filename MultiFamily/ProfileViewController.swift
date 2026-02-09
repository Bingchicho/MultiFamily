//
//  ProfileViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var mobileLabel: AppLabel!
    @IBOutlet weak var mobileTitleLabel: AppLabel!
    @IBOutlet weak var emailLabel: AppLabel!
    @IBOutlet weak var emailTitleLabel: AppLabel!
    @IBOutlet weak var nameLabel: AppLabel!
    @IBOutlet weak var editNameButton: ImageTextButton!
    @IBOutlet weak var nameTitleLabel: AppLabel!
    @IBOutlet weak var changePasswordButton: ImageTextButton!
    @IBOutlet weak var deleteAccountButton: ImageTextButton!
    @IBOutlet weak var logoutButton: ImageTextButton!
    @IBOutlet weak var editMobileButton: ImageTextButton!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       
    }
    
    private func setupUI() {
        self.title = "Profile"
        
        deleteAccountButton.tintColor = .error
        deleteAccountButton.setTitleColor(.error, for: .normal)
        
        nameTitleLabel.style = .title
        emailTitleLabel.style = .title
        mobileTitleLabel.style = .title
        
        nameLabel.style = .body
        emailLabel.style = .body
        mobileLabel.style = .body
        
        emailLabel.text = AppAssembler.userAttributeStore.currentEmail ?? "-"
        nameLabel.text = AppAssembler.userAttributeStore.currentUser?.username ?? "-"
        mobileLabel.text = AppAssembler.userAttributeStore.currentUser?.phone ?? "-"
        
    }
    


    @IBAction func editNameAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Edit Name",
            message: "Enter your name",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "Name"
            textField.text = AppAssembler.userAttributeStore.currentUser?.username
        }



        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            let firstName = alert.textFields?[0].text ?? ""
         

            let fullName = [firstName]
                .filter { !$0.isEmpty }
                .joined(separator: " ")

            self.nameLabel.text = fullName.isEmpty ? "-" : fullName
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func editMobileAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Edit Mobile",
            message: "Enter your mobile",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "mobile"
            textField.text = AppAssembler.userAttributeStore.currentUser?.phone
        }



        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            let phone = alert.textFields?[0].text ?? ""
         

            let fullPhone = [phone]
                .filter { !$0.isEmpty }
                .joined(separator: " ")

            self.mobileLabel.text = fullPhone.isEmpty ? "-" : fullPhone
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Change Password",
            message: "Enter your new password",
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = "New Password"
            textField.isSecureTextEntry = true
        }

        alert.addTextField { textField in
            textField.placeholder = "Confirm Password"
            textField.isSecureTextEntry = true
        }

        let confirm = UIAlertAction(title: "Confirm", style: .default) { _ in
            let newPassword = alert.textFields?[0].text ?? ""
            let confirmPassword = alert.textFields?[1].text ?? ""

            guard !newPassword.isEmpty,
                  newPassword == confirmPassword else {
                self.showSimpleAlert(
                    title: "Error",
                    message: "Passwords do not match"
                )
                return
            }

            // TODO: call change password use case
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        let alert = UIAlertController(
            title: "Delete Account",
            message: "Are you sure you want to delete your account?",
            preferredStyle: .alert
        )

        let confirm = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            // TODO: call delete account use case
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: "Logout",
            message: "Are you sure you want to logout?",
            preferredStyle: .alert
        )

        let confirm = UIAlertAction(title: "Confirm", style: .destructive) { _ in
            AppAssembler.tokenStore.clear()

            self.navigationController?.popToRootViewController(animated: true)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    private func showSimpleAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        alert.addAction(
            UIAlertAction(title: "OK", style: .default)
        )

        present(alert, animated: true)
    }
    
}
