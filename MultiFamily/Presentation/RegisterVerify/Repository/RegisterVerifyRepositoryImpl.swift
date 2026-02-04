//
//  RegisterVerifyRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

final class RegisterVerifyRepositoryImpl: RegisterVerifyRepository {

    

    private let apiClient: APIClient
    private let registerVerifyRequestFactory: RegsiterVerifyRequestFactoryProtocol

    init(
        apiClient: APIClient,
        registerVerifyFactory: RegsiterVerifyRequestFactoryProtocol
    ) {
        self.apiClient = apiClient
        self.registerVerifyRequestFactory = registerVerifyFactory
    }

    func verify(ticket: String, code: String) async throws -> RegisterVerifyResult   {

        let requestDTO = registerVerifyRequestFactory.makeRegisterVerifyRequest(ticket: ticket, code: code)
        
        let response: RegisterVerifyResponseDTO = try await apiClient.request(
            RegisterEndpoint.verify(requestDTO)
        )
        
        return response.toDomain()
    }
}
