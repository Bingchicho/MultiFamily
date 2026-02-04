//
//  Untitled.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/30.
//
import Foundation

enum LoginViewState {
    case idle
    case loading
    case error(String)
}
enum LoginRoute {
    case home
    case verification(ticket: String)
    case locked(until: Date)
}

final class LoginViewModel {

    // Input
    var email: String = "" { didSet { validate() } }
    var password: String = "" { didSet { validate() } }
    var isPasswordVisible = false

    // Output
    private(set) var isLoginEnabled: Bool = false
    // Output
    private(set) var state: LoginViewState = .idle {
        didSet {
            onStateChange?(state)
        }
    }

    var onStateChange: ((LoginViewState) -> Void)?
    var onRoute: ((LoginRoute) -> Void)?

    private let useCase: LoginUseCase

    init(useCase: LoginUseCase) {
        self.useCase = useCase
    }

    func togglePasswordVisibility() {
        isPasswordVisible.toggle()
    }

    func login() {
        guard isLoginEnabled else { return }

        state = .loading

        Task {
            let result = await useCase.login(email: email, password: password)

            DispatchQueue.main.async {
                self.handle(result)
            }
        }
    }

    private func handle(_ result: LoginResult) {
        state = .idle

        switch result {
        case .success:
            onRoute?(.home)

        case .verificationRequired(let ticket):
            onRoute?(.verification(ticket: ticket))

        case .locked(let until):
            onRoute?(.locked(until: until))

        case .failure:
            state = .error(L10n.Login.Error.invalid)
        }
    }

    private func validate() {
        isLoginEnabled = isValidEmail(email) && password.count >= 6
    }

    private func isValidEmail(_ value: String) -> Bool {
        value.contains("@") && value.contains(".")
    }
}
