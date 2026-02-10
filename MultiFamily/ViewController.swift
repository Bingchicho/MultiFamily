//
//  ViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import UIKit

@MainActor
final class ViewController: UIViewController {
    
    @IBOutlet weak var logoLabel: AppLabel!
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var loginButton: PrimaryButton!
    @IBOutlet weak var forgotButton: TextButton!
    @IBOutlet weak var registerButton: TextButton!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    private var viewModel: LoginViewModel?
    
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
        viewModel?.email = ""
        viewModel?.password = ""
        
        // Reset Button
        loginButton.isEnabled = false
        
        // Reset Loading
        loadingIndicator.stopAnimating()
        loadingIndicator.isHidden = true
        loadingBackground.isHidden = true
    }
    
    private func setupUI() {
        logoLabel.text = L10n.Login.title
        logoLabel.style = .title
        loginButton.isEnabled = false
        loadingIndicator.isHidden = true
        loadingBackground.isHidden = true
        registerButton.setTitle(L10n.Register.title, for: .normal)
        forgotButton.setTitle(L10n.Login.forgotPassword, for: .normal)
        loginButton.setTitle(L10n.Login.title, for: .normal)
        passwordTextField.enablePasswordToggle()
        accountTextField.placeholder = L10n.Login.Email.placeholder
        passwordTextField.placeholder = L10n.Login.Password.placeholder
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
    }
    
    private func bindViewModel() {
        
        let vm = LoginViewModel(
            useCase: AppAssembler.makeLoginUseCase()
        )
        
        viewModel = vm
        
        vm.onStateChange = { [weak self] state in
            guard let self else { return }
            self.render(state)
        }
        
        vm.onRoute = { [weak self] route in
            guard let self else { return }
            self.handle(route)
        }
        
        accountTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        
        checkRefreshToken()
    }
    
    private func checkRefreshToken() {
        
        guard AppAssembler.tokenStore.accessToken != nil else {
            return
        }
        
        viewModel?.refreshTokenIfNeeded()
    }
    
    @objc private func emailChanged() {
        viewModel?.email = accountTextField.text ?? ""
        loginButton.isEnabled = viewModel?.isLoginEnabled ?? false
    }
    
    @objc private func passwordChanged() {
        viewModel?.password = passwordTextField.text ?? ""
        loginButton.isEnabled = viewModel?.isLoginEnabled ?? false
    }
    
    private func holdLoading(animat: Bool) {
        
        if animat {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        
        loadingIndicator.isHidden = !animat
        loadingBackground.isHidden = !animat
        
        // Only disable current view interaction (avoid freezing navigation stack)
        view.isUserInteractionEnabled = !animat
    }
    
    private func render(_ state: LoginViewState) {
        switch state {
        case .idle:
            holdLoading(animat: false)
            loginButton.isEnabled = viewModel?.isLoginEnabled ?? false
            
        case .loading:
            holdLoading(animat: true)
            loginButton.isEnabled = false
            
        case .error(let message):
            holdLoading(animat: false)
            showErrorAlert(message)
        }
    }
    
    private func handle(_ route: LoginRoute) {
        switch route {
        case .home:
            
            self.performSegue(withIdentifier: "login", sender: nil)
            
        case .verification(let ticket):
            // 導向驗證頁
            print("Navigate to Verification with ticket:", ticket)
            
        }
    }
    
    private func showErrorAlert(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.Error.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func loginButtonAction(_ sender: UIButton) {
        viewModel?.login()
    }
    
    @IBAction func forgotButtonAction(_ sender: UIButton) {
        // 導向忘記密碼
    }
    
    @IBAction func signinButtonAction(_ sender: UIButton) {
        // 導向註冊
    }
    
    @IBAction func unwindToLogin(_ segue: UIStoryboardSegue) {
        resetUI()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
