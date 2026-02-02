//
//  ViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import UIKit

final class ViewController: UIViewController {

    @IBOutlet weak var logoLabel: AppLabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var loginButton: PrimaryButton!
    @IBOutlet weak var forgotButton: TextButton!
    @IBOutlet weak var registerButton: TextButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!

    var viewModel: LoginViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        bindViewModel()
        setupUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
    }
    private func resetUI() {
        // 清空輸入
        accountTextField.text = ""
        passwordTextField.text = ""
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()

        // Reset ViewModel
        viewModel.email = ""
        viewModel.password = ""

        // Reset Button
        loginButton.isEnabled = false

        // Reset Loading
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        loadingBackground.isHidden = true
    }

    private func setupUI() {
        logoLabel.text = L10n.loginTitle
        logoLabel.style = .title
        loginButton.isEnabled = false
        loadingIndicator.isHidden = true
        loadingBackground.isHidden = true
        registerButton.setTitle(L10n.registerTitle, for: .normal)
        forgotButton.setTitle(L10n.forgotPasswordTitle, for: .normal)
        loginButton.setTitle(L10n.loginTitle, for: .normal)
        passwordTextField.enablePasswordToggle()
        accountTextField.placeholder = L10n.emailPlaceholder
        passwordTextField.placeholder = L10n.passwordPlaceholder
 
    }

    private func bindViewModel() {
        
        viewModel = LoginViewModel(
            useCase: AppAssembler.makeLoginUseCase()
        )

        viewModel.onStateChange = { [weak self] state in
            DispatchQueue.main.async {
                self?.render(state)
            }
        }

        viewModel.onRoute = { [weak self] route in
            DispatchQueue.main.async {
                self?.handle(route)
            }
        }

        accountTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
    }

    @objc private func emailChanged() {
        viewModel.email = accountTextField.text ?? ""
        loginButton.isEnabled = viewModel.isLoginEnabled
    }

    @objc private func passwordChanged() {
        viewModel.password = passwordTextField.text ?? ""
        loginButton.isEnabled = viewModel.isLoginEnabled
    }

    private func render(_ state: LoginViewState) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            loadingBackground.isHidden = true
            loginButton.isEnabled = viewModel.isLoginEnabled

        case .loading:
            loadingBackground.isHidden = false
            loadingIndicator.isHidden = false
            loadingIndicator.startAnimating()
            loginButton.isEnabled = false

        case .error(let message):
            loadingIndicator.stopAnimating()
            loadingIndicator.isHidden = true
            loadingBackground.isHidden = true
            showErrorAlert(message)
        }
    }

    private func handle(_ route: LoginRoute) {
        switch route {
        case .home:
            // 導向首頁
            print("Navigate to Home")

        case .verification(let ticket):
            // 導向驗證頁
            print("Navigate to Verification with ticket:", ticket)

        case .locked(let until):
            showErrorAlert("帳號已鎖定至 \(until)")
        }
    }

    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: L10n.errorTitle, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.confirmButton, style: .default))
        present(alert, animated: true)
    }

    // MARK: - Actions

    @IBAction func loginButtonAction(_ sender: UIButton) {
        viewModel.login()
    }

    @IBAction func forgotButtonAction(_ sender: UIButton) {
        // 導向忘記密碼
    }

    @IBAction func signinButtonAction(_ sender: UIButton) {
        // 導向註冊
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
