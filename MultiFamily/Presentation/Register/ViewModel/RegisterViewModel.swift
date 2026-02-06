//
//  RegisterViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

import Foundation

@MainActor
final class RegisterViewModel {

    // MARK: - Input
    var email: String = "" { didSet { validate() } }
    var password: String = "" { didSet { validate() } }
    var confirmPassword: String = "" { didSet { validate() } }
    var name: String = "" { didSet { validate() } }
    var phone: String = ""
    var country: String = ""


    // MARK: - Output
    private(set) var isRegisterEnabled: Bool = false
    private(set) var state: RegisterViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((RegisterViewState) -> Void)?
    var onRoute: ((RegisterRoute) -> Void)?
    var onOpenLink: ((RegisterLink) -> Void)?

    // MARK: - Dependency
    private let useCase: RegisterUseCase

    init(useCase: RegisterUseCase) {
        self.useCase = useCase
    }

    // MARK: - Action
    func register() {
        guard isRegisterEnabled else { return }

        state = .loading

        Task { [weak self] in
            guard let self = self else { return }

            let result = await useCase.register(
                email: self.email,
                password: self.password,
                name: self.name,
                phone: self.phone.isEmpty ? nil : self.phone,
                country: self.country.isEmpty ? nil : self.country
            )

            self.handle(result)
        }
    }


    
    func didTapTerms() {
        onOpenLink?(.terms)
    }

    func didTapPrivacy() {
        onOpenLink?(.privacy)
    }

    // MARK: - Private
    private func handle(_ result: RegisterResult) {
        state = .idle

        switch result {
        case .success(ticket: let ticket):
            onRoute?(.verification(email: email, ticket: ticket))
        case .failure(let message):
            state = .error(message: message)

        }
 
    }

    private func validate() {
        isRegisterEnabled =
            isValidEmail(email) &&
            password.count >= 6 &&
            password == confirmPassword &&
            !name.isEmpty
    }

    private func isValidEmail(_ value: String) -> Bool {
        value.contains("@") && value.contains(".")
    }
}
