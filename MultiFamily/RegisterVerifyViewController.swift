//
//  RegisterVerifyViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

import UIKit

class RegisterVerifyViewController: UIViewController {
    
    var email: String?
    var ticket: String?
    
    @IBOutlet weak var contentLabel: AppLabel!
    @IBOutlet weak var emailLabel: AppLabel!
    
    @IBOutlet weak var verifyCodeTextField: UITextField!
    @IBOutlet weak var resendButton: TextButton!
    
    @IBOutlet weak var verifyButton: PrimaryButton!
    
    var viewModel: RegisterVerifyViewModel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = L10n.Register.title
        setLeftTopBackButton()
        setupUI()
        
        bindViewModel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func bindViewModel() {
        
        viewModel = RegisterVerifyViewModel(
            email: email ?? "",
            ticket: ticket ?? "",
            useCase: AppAssembler.makeRegisterVerifyUseCase()
        )

        // state → UI
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }

        // route → navigation
        viewModel.onRoute = { [weak self] route in
            self?.handle(route)
        }
        
        verifyCodeTextField.addTarget(self, action: #selector(codeChanged), for: .editingChanged)
    }
    
    @objc private func codeChanged() {
        viewModel.code = verifyCodeTextField.text ?? ""
        verifyButton.isEnabled = viewModel.isVerifyEnabled
    }
    
    private func render(_ state: RegisterVerifyViewState) {
        switch state {

        case .idle:
            holdLoading(animat: false)
            verifyButton.isEnabled = viewModel.isVerifyEnabled
            resendButton.isEnabled = true
            resendButton.setTitle(L10n.Verify.Button.resend, for: .normal)

        case .loading:
            holdLoading(animat: true)
            verifyButton.isEnabled = false

        case .error(let message):
            holdLoading(animat: false)
            showError(message)
        case .resendCooldown(let remaining):
            resendButton.isEnabled = false

            let title = L10n.Verify.Resend.cooldown(remaining)
            if resendButton.title(for: .normal) != title {
                UIView.performWithoutAnimation {
                    resendButton.setTitle(title, for: .normal)
                    resendButton.layoutIfNeeded()
                }
            }
        }
    }
    
    private func handle(_ route: RegisterVerifyRoute) {
        switch route {

        case .login:
            showSuccessAlert {
                self.navigationController?.popToRootViewController(animated: true)
            }
        case .resend:
            showResendSuccessAlert()
        }
    }
    
    private func holdLoading(animat: Bool) {
        if animat {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        
        loadingIndicator.isHidden = !animat
        loadingBackground.isHidden = !animat
        
        view.isUserInteractionEnabled = !animat
         navigationController?.view.isUserInteractionEnabled = !animat
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
    
    private func showSuccessAlert(onConfirm: @escaping () -> Void) {
        let alert = UIAlertController(
            title: L10n.Verify.Success.title,
            message: L10n.Verify.Success.content,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(
                title: L10n.Common.Button.confirm,
                style: .default,
                handler: { _ in
                    onConfirm()
                }
            )
        )
        present(alert, animated: true)
    }
    
    private func showResendSuccessAlert() {
        let alert = UIAlertController(
            title: L10n.Verify.Resend.success(email ?? ""),
            message: nil,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default))
        present(alert, animated: true)
    }
    
    private func setupUI() {
        contentLabel.style = .secondary
        emailLabel.style = .body

        verifyButton.isEnabled = false
        
        contentLabel.text = L10n.Verify.content
        emailLabel.text = email
        verifyCodeTextField.placeholder = L10n.Verify.Code.placeholder
        resendButton.setTitle(L10n.Verify.Button.resend, for: .normal)
        verifyButton.setTitle(L10n.Verify.Button.verify, for: .normal)
        
    }
    
    private func setLeftTopBackButton() {
        navigationItem.hidesBackButton = true
        
        let backItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backToLogin)
        )
        
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc private func backToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    
    @IBAction  func resendButtonTapped(_ sender: Any) {
        viewModel.resend()
    }
    
    @IBAction  func verifyButtonTapped(_ sender: Any) {
        viewModel.verify()
    }
    
}


