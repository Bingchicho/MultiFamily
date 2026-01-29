//
//  UserRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

final class UserRepositoryImpl: UserRepository {
    
    
    
    private let apiClient: APIClient
    private var tokenStore: TokenStore
    private let userRequestFactory: UserRequestFactory
    
    init(apiClient: APIClient, tokenStore: TokenStore, userRequestFactory: UserRequestFactory) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
        self.userRequestFactory = userRequestFactory
    }
    
    func login(email: String, password: String) async throws -> UserToken {
        
        
        let requestDTO = userRequestFactory.makeLoginRequest(
            email: email,
            password: password
        )
        
        let response: UserResponseDTO = try await apiClient.request(
            UserEndpoint.login(requestDTO)
        )
        
        
        let token = response.toDomain()
        
        tokenStore.accessToken = token.accessToken
        tokenStore.refreshToken = token.refreshToken
        
        return token
    }
    
    func refreshIfNeeded() async throws -> UserToken {
        let requestDTO = userRequestFactory.makeTokenRequest()
        let response: UserResponseDTO = try await apiClient.request(
            UserEndpoint.login(requestDTO)
        )
        
        let token = response.toDomain()
        
        tokenStore.accessToken = token.accessToken
        tokenStore.refreshToken = token.refreshToken
        
        return token
    }
}
