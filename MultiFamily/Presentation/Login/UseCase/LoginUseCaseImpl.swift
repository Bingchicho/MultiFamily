import Foundation

final class LoginUseCaseImpl: LoginUseCase {

    private let repository: UserRepository


    init(
        repository: UserRepository
    ) {
        self.repository = repository

    }

    // MARK: - Public API

    func login(email: String, password: String) async -> LoginResult {
        await execute {
            try await repository.login(email: email, password: password)
        }
    }

    func refreshToken() async -> LoginResult {
        await execute {
            try await repository.refreshIfNeeded()
        }
    }

    // MARK: - Private

    /// Centralized execution wrapper to avoid duplicated error handling
    private func execute(
        _ block: () async throws -> Void
    ) async -> LoginResult {

        do {
            try await block()
            return .success
        } catch {
            AppAssembler.tokenStore.clear()
            AppAssembler.userAttributeStore.clear()
            return mapErrorToLoginResult(error)
        }
    }

    /// Maps infrastructure / API errors into presentation-friendly LoginResult
    private func mapErrorToLoginResult(_ error: Error) -> LoginResult {

        guard let apiError = error as? APIClientError else {
            return .failure(.unknown)
        }

        switch apiError {

        case .httpStatus(let code, let data):

            switch code {

            case 423:
                return mapVerificationRequired(data)

            case 401:
                return .failure(.invalidCredentials)

            default:
                return .failure(.unknown)
            }

        case .timeout:
            return .failure(.network)

        case .invalidResponse:
            return .failure(.network)

        }
    }

    private func mapVerificationRequired(_ data: Data) -> LoginResult {

        guard
            let dto = try? JSONDecoder().decode(
                VerificationRequiredDTO.self,
                from: data
            ),
            !dto.ticket.isEmpty
        else {
            return .failure(.unknown)
        }

        return .verificationRequired(ticket: dto.ticket)
    }
}
