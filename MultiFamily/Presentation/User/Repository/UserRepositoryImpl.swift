//
//  UserRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

protocol UserRepository {
    func list() async throws -> UserListResult
}


final class UserRepositoryImpl: UserRepository {

    

    private let apiClient: APIClient
    private var tokenStore: TokenStore
    private let userRequestFactory: applicationIDRequestFactoryProtocol


    init(
        apiClient: APIClient,
        tokenStore: TokenStore,
        userRequestFactory: applicationIDRequestFactoryProtocol,

    ) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
        self.userRequestFactory = userRequestFactory
   
    }

   
    
    func list() async throws -> UserListResult {
        
        let requestDTO = userRequestFactory.makeListRequest()
        
        let dto: UserListResponseDTO = try await apiClient.request(
            AuthEndpoint.list(requestDTO)
        )

        let domain = dto.toDomain()

        return UserListResult(
            users: domain.users,
            inviteUsers: domain.inviteUsers
        )
    }
}
