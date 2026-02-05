//
//  ForgotPasswordViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//
import Foundation

final class ForgotPasswordViewModel {

    // MARK: - Input
    var email: String = "" { didSet { validate() } }
    var code: String = "" { didSet { validate() } }
    var newPassword: String = "" { didSet { validate() } }
    var confirmPassword: String = "" { didSet { validate() } }

    // MARK: - Output
    private(set) var state: ForgotPasswordViewState = .idle {
        didSet { onStateChange?(state) }
    }

    private(set) var isSendCodeEnabled = false
    private(set) var isConfirmEnabled = false

    var onStateChange: ((ForgotPasswordViewState) -> Void)?
    var onRoute: ((ForgotPasswordRoute) -> Void)?

    // MARK: - Dependencies
    private let useCase: ForgotPasswordUseCase

    // MARK: - Cooldown
    private let cooldown: TimeInterval = 30
    private var resendEndDate: Date?
    private var timer: Timer?

    init(useCase: ForgotPasswordUseCase) {
        self.useCase = useCase
    }
    
    private func validate() {
        isSendCodeEnabled = isValidEmail(email)

        isConfirmEnabled =
            !code.isEmpty &&
            newPassword.count >= 6 &&
            newPassword == confirmPassword
    }
    
    private func isValidEmail(_ value: String) -> Bool {
        value.contains("@") && value.contains(".")
    }
    
    func sendCode() {
        guard isSendCodeEnabled else { return }

        state = .loading

        Task {
            let result = await useCase.sendCode(email: email)

            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.state = .sendedCode(email: self.email)
                    self.startCooldown()
                case .failure(let message):
                    self.state = .error(message)
                }
            }
        }
    }
    
    func confirm() {
        guard isConfirmEnabled else { return }

        state = .loading

        Task {
            let result = await useCase.resetPassword(
                email: email,
                code: code,
                newPassword: newPassword
            )

            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.onRoute?(.login)
                case .failure(let message):
                    self.state = .error(message)
                }
            }
        }
    }
    
    private func startCooldown() {
        resendEndDate = Date().addingTimeInterval(cooldown)
        tick()
        startTimer()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        guard let end = resendEndDate else { return }

        let remaining = Int(end.timeIntervalSinceNow)

        if remaining <= 0 {
            timer?.invalidate()
            resendEndDate = nil
            state = .codeSent(remaining: nil)
        } else {
            state = .codeSent(remaining: remaining)
        }
    }
}
