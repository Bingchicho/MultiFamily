//
//  RegisterVerifyViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//
import Foundation

@MainActor
final class RegisterVerifyViewModel {
    


    // MARK: - Input
    var code: String = "" {
        didSet { validate() }
    }

    // MARK: - Output
    private(set) var isVerifyEnabled: Bool = false
    private(set) var state: RegisterVerifyViewState = .idle {
        didSet { onStateChange?(state) }
    }
    
    // MARK: - Cooldown
    private let resendCooldownSeconds = 60
    private var resendRemaining = 0
    private var resendTimer: Timer?

    var isResendEnabled: Bool {
        resendRemaining == 0 && !state.isLoading
    }

    var onStateChange: ((RegisterVerifyViewState) -> Void)?
    var onRoute: ((RegisterVerifyRoute) -> Void)?

    // MARK: - Dependency
    private let email: String
    private var ticket: String
    private let useCase: RegisterVerifyUseCase

    init(
        email: String,
        ticket: String,
        useCase: RegisterVerifyUseCase
    ) {
        self.email = email
        self.ticket = ticket
        self.useCase = useCase
    }

    // MARK: - Action
    func verify() {
        guard isVerifyEnabled else { return }

        state = .loading

        Task { [weak self] in
            guard let self = self else { return }

            let result = await useCase.verify(ticket: self.ticket, code: self.code)

            self.handle(result)
        }
    }
    
    func resend() {
        guard isResendEnabled else { return }

        state = .loading

        Task { [weak self] in
            guard let self = self else { return }

            let result = await useCase.resend(email: self.email)

            self.handleResend(result)
        }
    }

    // MARK: - Private
    
    private func startResendCooldown() {
        resendTimer?.invalidate()

        resendRemaining = resendCooldownSeconds
        state = .resendCooldown(remaining: resendRemaining)

        resendTimer = Timer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true
        ) { [weak self] timer in
            guard let self = self else { return }

            self.resendRemaining -= 1

            if self.resendRemaining <= 0 {
                timer.invalidate()
                self.resendRemaining = 0
                self.state = .idle
            } else {
                self.state = .resendCooldown(remaining: self.resendRemaining)
            }
        }
    }
    
    private func handleResend(_ result: VerifyResendResult) {
        state = .idle

        switch result {
        case .success(let ticket):
            self.startResendCooldown()
            self.ticket = ticket
            onRoute?(.resend)

        case .failure(let message):
            state = .error(message)
        }
    }
    
    
    private func handle(_ result: RegisterVerifyResult) {
        state = .idle

        switch result {
        case .success:
            onRoute?(.login)

        case .failure(let message):
            state = .error(message)
        }
    }

    private func validate() {
        isVerifyEnabled = code.count >= 6
    }
    
    deinit {
        resendTimer?.invalidate()
    }
}
