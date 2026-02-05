//
//  ForgotPasswordRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//

final class ForgotPasswordRepositoryImpl: ForgotPasswordRepository {

    private let apiClient: APIClient
    private let registerForgotPasswordFactory: ForgotPasswordRequestFactoryProtocol
    private var ticket: String?

    init(
        apiClient: APIClient,
        requestFactory: ForgotPasswordRequestFactoryProtocol
    ) {
        self.apiClient = apiClient
        self.registerForgotPasswordFactory = requestFactory
    }

    func sendCode(email: String) async throws {

        
        let requestDTO = registerForgotPasswordFactory.makeForgotPasswordSendCodeRequestFactory(email: email)
        
        let response: ForgotPasswordSendCodeResponseDTO = try await apiClient.request(
            ForgotPasswordEndpoint.sendCode(requestDTO)
        )
        
        self.ticket = response.ticket

      
    }

    func resetPassword(email: String, code: String, newPassword: String) async throws {

        guard let ticket = ticket else { throw APIClientError.invalidResponse}
        let requestDTO = registerForgotPasswordFactory.makeForgotPasswordConfirmRequestFactory(ticket: ticket, code: code, email: email, password: newPassword)
        
        let response: ForgotPasswordSendCodeResponseDTO = try await apiClient.request(
            ForgotPasswordEndpoint.resetPassword(requestDTO)
        )
    }
}
