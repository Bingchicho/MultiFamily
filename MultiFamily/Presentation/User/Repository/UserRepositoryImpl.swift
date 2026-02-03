//
//  UserRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

final class UserRepositoryImpl: UserRepository {
    
    private let apiClient: APIClient
    private var tokenStore: TokenStore
    private let userRequestFactory: UserRequestFactoryProtocol
    private let userAttribute: UserAttributeStore
    
    init(apiClient: APIClient, tokenStore: TokenStore, userRequestFactory: UserRequestFactoryProtocol, userAttribute: UserAttributeStore) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
        self.userRequestFactory = userRequestFactory
        self.userAttribute = userAttribute
    }
    
    func login(email: String, password: String) async throws {
        
        
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
        
        let attribute = response.attribute.toDomain()
        userAttribute.save(attribute)
        
  
    }
    
    func refreshIfNeeded() async throws  {
        let requestDTO = userRequestFactory.makeTokenRequest()
        let response: UserResponseDTO = try await apiClient.request(
            UserEndpoint.login(requestDTO)
        )
        
        let token = response.toDomain()
        
        tokenStore.accessToken = token.accessToken
        tokenStore.refreshToken = token.refreshToken
        
        let attribute = response.attribute.toDomain()
        userAttribute.save(attribute)
        
  
    }
    
    
}
