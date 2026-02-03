//
//  RegisterRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//


final class RegisterRepositoryImpl: RegisterRepository {

    
    private let apiClient: APIClient

    private let registerRequestFactory: RegsiterRequestFactoryProtocol

    
    init(apiClient: APIClient, requestFactory: RegsiterRequestFactoryProtocol) {
        self.apiClient = apiClient
      
        self.registerRequestFactory = requestFactory
   
    }
    
    
    func create(email: String, password: String, name: String, phone: String?, country: String?) async throws -> RegisterResult {
        let requestDTO = registerRequestFactory.makeRegisterRequest(email: email, password: password, name: name, phone: phone, country: country)
        
        let response: RegisterResponseDTO = try await apiClient.request(
            RegisterEndpoint.create(requestDTO)
        )
        
        return response.toDomain()
    }
    
    
    
    
}
