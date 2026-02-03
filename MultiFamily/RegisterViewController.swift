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
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    var viewModel: RegisterViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L10n.registerTitle
        setupUI()
        bind()
    }
    
    private func bind() {
        viewModel = RegisterViewModel(
            useCase: AppAssembler.makeRegisterUseCase()
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
        
        viewModel.onOpenLink = { [weak self] link in
            DispatchQueue.main.async {
                self?.openURL(link.urlString)
            }
            
            
        }
        
        
        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        nametTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(phoneChanged), for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(countryChanged), for: .editingChanged)
    }
    
    @objc private func emailChanged() {
        viewModel.email = emailTextField.text ?? ""
        registerButton.isEnabled = viewModel.isRegisterEnabled
    }

    @objc private func passwordChanged() {
        viewModel.password = passwordTextField.text ?? ""
        registerButton.isEnabled = viewModel.isRegisterEnabled
    }
    
    @objc private func confirmPasswordChanged() {
        viewModel.confirmPassword = confirmPasswordTextField.text ?? ""
        registerButton.isEnabled = viewModel.isRegisterEnabled
    }
    
    @objc private func nameChanged() {
        viewModel.name = nametTextField.text ?? ""
        registerButton.isEnabled = viewModel.isRegisterEnabled
    }
    
    @objc private func phoneChanged() {
        viewModel.phone = phoneTextField.text ?? ""
    
    }
    
    @objc private func countryChanged() {
        viewModel.country = countryTextField.text ?? ""
    
    }
    
    private func setupUI() {
        registerButton.isEnabled = false
        
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
        setupUserTermsPrivacyPolicyText()
 
    }
    
    private func setupUserTermsPrivacyPolicyText() {
        let fullText =
            L10n.termsConditions1 + " " +
            L10n.termsConfitions + " " +
            L10n.termsConditions2 + " " +
            L10n.privacyPolicy

        let attributed = NSMutableAttributedString(string: fullText)

        let termsRange = (fullText as NSString).range(of: L10n.termsConfitions)
        let privacyRange = (fullText as NSString).range(of: L10n.privacyPolicy)

        attributed.addAttribute(.foregroundColor, value: AppTheme.current.primary, range: termsRange)
        attributed.addAttribute(.foregroundColor, value: AppTheme.current.primary, range: privacyRange)

        attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: termsRange)
        attributed.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: privacyRange)

        termsPrivacyLabel.attributedText = attributed
        termsPrivacyLabel.isUserInteractionEnabled = true

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTermsPrivacyTap(_:)))
        termsPrivacyLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTermsPrivacyTap(_ gesture: UITapGestureRecognizer) {
        guard let label = gesture.view as? UILabel,
              let text = label.attributedText?.string else { return }

        let location = gesture.location(in: label)

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: label.bounds.size)
        let textStorage = NSTextStorage(string: text)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = label.numberOfLines
        textContainer.lineBreakMode = label.lineBreakMode

        let index = layoutManager.characterIndex(
            for: location,
            in: textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        if (text as NSString).range(of: L10n.termsConfitions).contains(index) {
            viewModel.didTapTerms()
        } else if (text as NSString).range(of: L10n.privacyPolicy).contains(index) {
            viewModel.didTapPrivacy()
        }
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        UIApplication.shared.open(url)
    }
    
    private func holdLoading(animat: Bool) {
        if animat {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }
        
        loadingIndicator.isHidden = !animat
        loadingBackground.isHidden = !animat
    }
    
    private func render(_ state: RegisterViewState) {
        switch state {

        case .idle:
            registerButton.isEnabled = viewModel.isRegisterEnabled
            holdLoading(animat: false)

        case .loading:
            registerButton.isEnabled = false
            holdLoading(animat: true)

        case .error(let message):
            holdLoading(animat: false)
            registerButton.isEnabled = viewModel.isRegisterEnabled
            
            showError(message)
        }
    }
    
    private func handle(_ route: RegisterRoute) {
        switch route {
            
        case .verification(let email, let ticket):
            // 導向驗證頁
            //   let vc = VerificationViewController(email: email)
            //   navigationController?.pushViewController(vc, animated: true)
            break
        }
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: L10n.errorTitle,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L10n.confirmButton, style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        viewModel.register()
    }

}
