//
//  RegisterVerifyRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

final class RegisterVerifyRepositoryImpl: RegisterVerifyRepository {

    

    

    private let apiClient: APIClient
    private let registerVerifyRequestFactory: RegsiterVerifyRequestFactoryProtocol
    private let verifyResendRequestFactory: VerifyResendRequestFactoryProtocol

    init(
        apiClient: APIClient,
        registerVerifyFactory: RegsiterVerifyRequestFactoryProtocol,
        verifyResendFactory: VerifyResendRequestFactoryProtocol
    ) {
        self.apiClient = apiClient
        self.registerVerifyRequestFactory = registerVerifyFactory
        self.verifyResendRequestFactory = verifyResendFactory
    }

    func verify(ticket: String, code: String) async throws -> RegisterVerifyResult   {

        let requestDTO = registerVerifyRequestFactory.makeRegisterVerifyRequest(ticket: ticket, code: code)
        
        let response: RegisterVerifyResponseDTO = try await apiClient.request(
            RegisterEndpoint.verify(requestDTO)
        )
        
        return response.toDomain()
    }
    
    func resend(email: String) async throws -> VerifyResendResult {
        let requestDTO = verifyResendRequestFactory.makeVerifyResendRequest(email: email)
        
        let response: VerifyResendResponseDTO = try await apiClient.request(
            RegisterEndpoint.resend(requestDTO)
        )
        
        return response.toDomain()
    }
}
