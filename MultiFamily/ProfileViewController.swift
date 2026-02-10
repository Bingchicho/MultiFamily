//
//  ProfileViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

import UIKit
@MainActor
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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    private lazy var viewModel = ProfileViewModel(
        useCase: AppAssembler.makeProfileUseCase()
    )
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func bindViewModel() {


        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            self.render(state)
        }

        viewModel.onRoute = { [weak self] route in
            guard let self else { return }
            self.handle(route)
        }
        
        viewModel.onProfileUpdated = { [weak self] in
            guard let self else { return }
            self.updated()
        }
        
        viewModel.load()
        
        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
        mobileLabel.text = viewModel.phone
        
        
    }
    
    private func updated() {
        viewModel.load()
    }
    
    private func render(_ state: ProfileViewState) {
        
        switch state {

        case .idle:
        
            holdLoading(animat: false)

        case .loading:
          
            holdLoading(animat: true)

        case .error(let message):
            holdLoading(animat: false)
  
            
            showError(message)
        }
        
        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
        mobileLabel.text = viewModel.phone
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: L10n.Common.Error.title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default))
        present(alert, animated: true)
    }
    
    private func holdLoading(animat: Bool) {

        if animat {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }

        loadingIndicator.isHidden = !animat
        loadingBackground.isHidden = !animat

        // Only disable current screen interaction (avoid navigation freeze)
        view.isUserInteractionEnabled = !animat
    }
    
    private func handle(_ route: ProfileRoute) {

        switch route {

        case .logout,
             .deleted:

            self.performSegue(withIdentifier: "logout", sender: nil)
        }
    }
    
    private func setupUI() {
        self.title = L10n.Profile.title
        
        deleteAccountButton.tintColor = .error
        deleteAccountButton.setTitleColor(.error, for: .normal)
        
        nameTitleLabel.style = .title
        emailTitleLabel.style = .title
        mobileTitleLabel.style = .title
        
        nameLabel.style = .body
        emailLabel.style = .body
        mobileLabel.style = .body
        
        nameTitleLabel.text = L10n.Profile.Name.title
        emailTitleLabel.text = L10n.Profile.Email.title
        mobileTitleLabel.text = L10n.Profile.Mobile.title
        editNameButton.setTitle(L10n.Profile.Button.edit, for: .normal)
        editMobileButton.setTitle(L10n.Profile.Button.edit, for: .normal)
        
        changePasswordButton.setTitle(L10n.Profile.Button.changePassword, for: .normal)
        deleteAccountButton.setTitle(L10n.Profile.Button.deleteAccount, for: .normal)
        logoutButton.setTitle(L10n.Profile.Button.logout, for: .normal)
        
    }
    


    @IBAction func editNameAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: L10n.Profile.Alert.EditName.title,
            message: L10n.Profile.Alert.EditName.content,
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = L10n.Profile.Alert.EditName.placeholder
            textField.text = AppAssembler.userAttributeStore.currentUser?.username
        }



        let confirm = UIAlertAction(title: L10n.Common.Button.confirm, style: .default) { _ in
            if let firstName = alert.textFields?[0].text{
                self.viewModel.updateName(firstName)
            }
    
        }

        let cancel = UIAlertAction(title: L10n.Common.Button.cancel, style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func editMobileAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: L10n.Profile.Alert.EditMobile.title,
            message: L10n.Profile.Alert.EditName.content,
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = L10n.Profile.Alert.EditMobile.placeholder
            textField.text = AppAssembler.userAttributeStore.currentUser?.phone
        }



        let confirm = UIAlertAction(title: L10n.Common.Button.confirm, style: .default) { _ in
            if let phone = alert.textFields?[0].text {
                self.viewModel.changeMobile(phone)
            }
         
            
        }

        let cancel = UIAlertAction(title: L10n.Common.Button.cancel, style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func changePasswordAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: L10n.Profile.Alert.ChangePassword.title,
            message: L10n.Profile.Alert.ChangePassword.content,
            preferredStyle: .alert
        )
        
        alert.addTextField { textField in
            textField.placeholder = L10n.Profile.Alert.ChangePassword.OldPassword.placeholder
            textField.isSecureTextEntry = true
        }

        alert.addTextField { textField in
            textField.placeholder = L10n.Profile.Alert.ChangePassword.NewPassword.placeholder
            textField.isSecureTextEntry = true
        }

        alert.addTextField { textField in
            textField.placeholder = L10n.Profile.Alert.ChangePassword.ConfirmPassword.placeholder
            textField.isSecureTextEntry = true
        }

        let confirm = UIAlertAction(title: L10n.Common.Button.confirm, style: .default) { _ in
            let oldPassword = alert.textFields?[0].text ?? ""
            let newPassword = alert.textFields?[1].text ?? ""
            let confirmPassword = alert.textFields?[2].text ?? ""

            guard !newPassword.isEmpty,
                  newPassword == confirmPassword else {
                self.showSimpleAlert(
                    title: L10n.Common.Error.title,
                    message: L10n.Profile.Alert.ChangePassword.Error.notMatch
                )
                return
            }

            self.viewModel.changePassword(oldPassword: oldPassword, newPassword: newPassword)
        }

        let cancel = UIAlertAction(title: L10n.Common.Button.cancel, style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func deleteAccountAction(_ sender: Any) {
        let alert = UIAlertController(
            title: L10n.Profile.Alert.DeleteAccount.title,
            message: L10n.Profile.Alert.DeleteAccount.content,
            preferredStyle: .alert
        )

        let confirm = UIAlertAction(title: L10n.Common.Button.confirm, style: .destructive) { _ in
            self.viewModel.deleteAccount()
        }

        let cancel = UIAlertAction(title: L10n.Common.Button.cancel, style: .cancel)

        alert.addAction(confirm)
        alert.addAction(cancel)

        present(alert, animated: true)
    }
    
    @IBAction func logoutAction(_ sender: UIButton) {
        let alert = UIAlertController(
            title: L10n.Profile.Alert.Logout.title,
            message: L10n.Profile.Alert.Logout.content,
            preferredStyle: .alert
        )

        let confirm = UIAlertAction(title: L10n.Common.Button.confirm, style: .destructive) { _ in
            self.viewModel.logout()
        }

        let cancel = UIAlertAction(title: L10n.Common.Button.cancel, style: .cancel)

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
            UIAlertAction(title: L10n.Common.Button.confirm, style: .default)
        )

        present(alert, animated: true)
    }
    
}
