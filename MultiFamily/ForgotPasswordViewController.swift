//
//  ForgotPasswordViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

import UIKit

@MainActor
final class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var verifyButton: PrimaryButton!
    @IBOutlet weak var changeStackView: UIStackView!
    
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var resendButton: TextButton!
    
    @IBOutlet weak var passwordTextField: PasswordTextField!
    @IBOutlet weak var confirmPasswordTextField: PasswordTextField!
    
    @IBOutlet weak var confirmButton: PrimaryButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    private var viewModel: ForgotPasswordViewModel?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L10n.Forgotpassword.title
        setupKeyboardHandling()
        setupUI()
        bindViewModel()
        
    }
    
    private func bindViewModel() {

        let vm = ForgotPasswordViewModel(
            useCase: AppAssembler.makeForgotPasswordUseCase()
        )

        viewModel = vm

        vm.onStateChange = { [weak self] state in
            self?.render(state)
        }

        vm.onRoute = { [weak self] route in
            self?.handle(route)
        }

        verifyButton.isEnabled = vm.isSendCodeEnabled
    }
    
    private func holdLoading(animat: Bool) {

        if animat {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }

        loadingIndicator.isHidden = !animat
        loadingBackground.isHidden = !animat

        // Disable only current view interaction to avoid unexpected navigation lock
        view.isUserInteractionEnabled = !animat
    }
    
    private func render(_ state: ForgotPasswordViewState) {
        
        switch state {
            
        case .idle:
            holdLoading(animat: false)
            changeStackView.isHidden = true
            verifyButton.isEnabled = viewModel?.isSendCodeEnabled ?? false
            confirmButton.isEnabled = false
            
        case .loading:
            holdLoading(animat: true)
            verifyButton.isEnabled = false
            confirmButton.isEnabled = false
        case .sendedCode(let email):
            verifyButton.isEnabled = false
            showSendSuccess(email)
        case .codeSent(let remaining):
   
            changeStackView.isHidden = false
            confirmButton.isEnabled = viewModel?.isConfirmEnabled ?? false
            
            if let remaining = remaining {

                let title = L10n.Forgotpassword.Code.resend(remaining)
                if resendButton.title(for: .normal) != title {
                    UIView.performWithoutAnimation {
                        resendButton.setTitle(title, for: .normal)
                        resendButton.layoutIfNeeded()
                    }
                }
                resendButton.isEnabled = false
            } else {
                resendButton.setTitle(L10n.Forgotpassword.Button.resend, for: .normal)
                resendButton.isEnabled = true
            }
            
        case .error(let message):
            holdLoading(animat: false)
            showError(message)
        }
    }
    
    private func showSendSuccess(_ message: String) {
        let alert = UIAlertController(
            title: L10n.Common.Notice.title,
            message: L10n.Forgotpassword.Code.success(message),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default))
        present(alert, animated: true)
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
    
    private func handle(_ route: ForgotPasswordRoute) {
        switch route {
        case .login:
            showResetSuccess()
          
        }
    }
    private func showResetSuccess() {
        let alert = UIAlertController(
            title: L10n.Forgotpassword.Success.title,
            message: L10n.Forgotpassword.Success.content,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    
    @IBAction func emailChanged(_ sender: UITextField) {
        viewModel?.email = sender.text ?? ""
        verifyButton.isEnabled = viewModel?.isSendCodeEnabled ?? false
    }
    
    @IBAction func codeChanged(_ sender: UITextField) {
        viewModel?.code = sender.text ?? ""
    }
    
    @IBAction func passwordChanged(_ sender: UITextField) {
        viewModel?.newPassword = sender.text ?? ""
    }
    
    @IBAction func confirmPasswordChanged(_ sender: UITextField) {
        viewModel?.confirmPassword = sender.text ?? ""
    }
    
    private func setupUI() {
        
        changeStackView.isHidden = true
        confirmButton.isEnabled = false
        
        emailTextField.placeholder = L10n.Forgotpassword.Email.placeholder
        verifyButton.setTitle(L10n.Forgotpassword.Button.getcode, for: .normal)
        
        verifyCodeTextField.placeholder = L10n.Forgotpassword.Code.placeholder
        resendButton.setTitle(L10n.Forgotpassword.Button.resend, for: .normal)
        
        passwordTextField.placeholder = L10n.Forgotpassword.Password.title
        confirmPasswordTextField.placeholder = L10n.Forgotpassword.ConfirmPassword.title
        
        confirmButton.setTitle(L10n.Common.Button.confirm, for: .normal)
        
        passwordTextField.enablePasswordToggle()
        confirmPasswordTextField.enablePasswordToggle()
        
    }
    
    private func setupKeyboardHandling() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard
            let info = notification.userInfo,
            let keyboardFrame = info[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect
        else { return }
        
        let bottomInset = keyboardFrame.height - view.safeAreaInsets.bottom
        
        scrollView.contentInset.bottom = bottomInset + 16
        scrollView.verticalScrollIndicatorInsets.bottom = bottomInset
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        scrollView.contentInset.bottom = 0
        scrollView.verticalScrollIndicatorInsets.bottom = 0
    }
    
    @IBAction func verifyButtonAction(_ sender: UIButton) {
        viewModel?.sendCode()
    }
    
    
    @IBAction func confirmButtonAction(_ sender: UIButton) {
        viewModel?.confirm()
    }
    
    @IBAction func resendButtonAction(_ sender: UIButton) {
        viewModel?.sendCode()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
