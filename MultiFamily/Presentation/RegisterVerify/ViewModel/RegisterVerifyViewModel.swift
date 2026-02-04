//
//  RegisterVerifyViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//
import Foundation

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

    var onStateChange: ((RegisterVerifyViewState) -> Void)?
    var onRoute: ((RegisterVerifyRoute) -> Void)?

    // MARK: - Dependency
    private let email: String
    private let ticket: String
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

        Task {
            let result = await useCase.verify(ticket: ticket,code: code)

            DispatchQueue.main.async {
                self.handle(result)
            }
        }
    }

    // MARK: - Private
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
}
