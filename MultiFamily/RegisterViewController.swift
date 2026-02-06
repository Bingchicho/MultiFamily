//
//  SiginViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/2.
//

import UIKit

@MainActor
final class RegisterViewController: UIViewController {
    
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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var termsPrivacyLabel: AppLabel!
    
    @IBOutlet weak var registerButton: PrimaryButton!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    private var viewModel: RegisterViewModel?
    private var verifyEmail: String?
    private var verifyTicket: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = L10n.Register.title
        setupKeyboardHandling()
        setupUI()
        bind()
    }
    
    private func bind() {

        let vm = RegisterViewModel(
            useCase: AppAssembler.makeRegisterUseCase()
        )

        viewModel = vm

        vm.onStateChange = { [weak self] state in
            self?.render(state)
        }

        vm.onRoute = { [weak self] route in
            self?.handle(route)
        }

        vm.onOpenLink = { [weak self] link in
            self?.openURL(link.urlString)
        }

        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(passwordChanged), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(confirmPasswordChanged), for: .editingChanged)
        nametTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        phoneTextField.addTarget(self, action: #selector(phoneChanged), for: .editingChanged)
        countryTextField.addTarget(self, action: #selector(countryChanged), for: .editingChanged)
    }
    
    @objc private func emailChanged() {
        viewModel?.email = emailTextField.text ?? ""
        registerButton.isEnabled = viewModel?.isRegisterEnabled ?? false
    }

    @objc private func passwordChanged() {
        viewModel?.password = passwordTextField.text ?? ""
        registerButton.isEnabled = viewModel?.isRegisterEnabled ?? false
    }
    
    @objc private func confirmPasswordChanged() {
        viewModel?.confirmPassword = confirmPasswordTextField.text ?? ""
        registerButton.isEnabled = viewModel?.isRegisterEnabled ?? false
    }
    
    @objc private func nameChanged() {
        viewModel?.name = nametTextField.text ?? ""
        registerButton.isEnabled = viewModel?.isRegisterEnabled ?? false
    }
    
    @objc private func phoneChanged() {
        viewModel?.phone = phoneTextField.text ?? ""
    
    }
    
    @objc private func countryChanged() {
        viewModel?.country = countryTextField.text ?? ""
    
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
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
        
        emailLabel.text = L10n.Register.Email.title
        passwordLabel.text = L10n.Register.Password.title
        confirmPasswordLabel.text = L10n.Register.ConfirmPassword.title
        nameLabel.text = L10n.Register.Name.title
        phoneLabel.text = L10n.Register.Phone.title
        countryLabel.text = L10n.Register.Country.title
        
        emailTextField.placeholder = L10n.Register.Email.placeholder
        passwordTextField.placeholder = L10n.Register.Password.placeholder
        confirmPasswordTextField.placeholder = L10n.Register.ConfirmPassword.placeholder
        nametTextField.placeholder = L10n.Register.Name.placeholder
        phoneTextField.placeholder = L10n.Register.Option.placeholder
        countryTextField.placeholder = L10n.Register.Option.placeholder
        
        passwordTextField.enablePasswordToggle()
        confirmPasswordTextField.enablePasswordToggle()
        
        registerButton.setTitle(L10n.Register.title, for: .normal)
        setupUserTermsPrivacyPolicyText()
 
    }
    
    private func setupUserTermsPrivacyPolicyText() {
        let fullText =
        L10n.Register.Terms.prefix + " " +
        L10n.Register.Terms.terms + " " +
        L10n.Register.Terms.middle + " " +
        L10n.Register.Terms.privacy

        let attributed = NSMutableAttributedString(string: fullText)

        let termsRange = (fullText as NSString).range(of: L10n.Register.Terms.terms)
        let privacyRange = (fullText as NSString).range(of: L10n.Register.Terms.privacy)

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

        if (text as NSString).range(of: L10n.Register.Terms.terms).contains(index) {
            viewModel?.didTapTerms()
        } else if (text as NSString).range(of: L10n.Register.Terms.privacy).contains(index) {
            viewModel?.didTapPrivacy()
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

        // Only disable current screen interaction (avoid navigation freeze)
        view.isUserInteractionEnabled = !animat
    }
    
    private func render(_ state: RegisterViewState) {
        switch state {

        case .idle:
            registerButton.isEnabled = viewModel?.isRegisterEnabled ?? false
            holdLoading(animat: false)

        case .loading:
            registerButton.isEnabled = false
            holdLoading(animat: true)

        case .error(let message):
            holdLoading(animat: false)
            registerButton.isEnabled = viewModel?.isRegisterEnabled ?? false
            
            showError(message)
        }
    }
    
    private func handle(_ route: RegisterRoute) {
        switch route {
            
        case .verification(let email, let ticket):
            self.verifyEmail = email
            self.verifyTicket = ticket
            self.performSegue(withIdentifier: "verify", sender: nil)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "verify",
           let vc = segue.destination as? RegisterVerifyViewController {
            vc.email = verifyEmail
            vc.ticket = verifyTicket ?? ""
        }
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
    
    @IBAction func registerButtonAction(_ sender: UIButton) {
        viewModel?.register()
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
