//
//  UserRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

protocol UserRepository {
    func list() async throws -> UserListResult
    func update(siteId: String, userId: String, role: UserRole) async throws
    func delete(siteId: String, userId: String) async throws
    func inviteResend(code: String) async throws
    func inviteDelete(code: String) async throws
    func inviteUser(email: String, permission: UserPermission) async throws
}


final class UserRepositoryImpl: UserRepository {

    


    private let apiClient: APIClient
    private var tokenStore: TokenStore
    private let applicationFactory:applicationIDRequestFactoryProtocol
    private let userRequestFactory: UserRequestFactoryProtocol


    init(
        apiClient: APIClient,
        tokenStore: TokenStore,
        applicationFactory: applicationIDRequestFactoryProtocol,
        userRequestFactory: UserRequestFactoryProtocol,

    ) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
        self.applicationFactory = applicationFactory
        self.userRequestFactory = userRequestFactory
   
    }

   
    
    func list() async throws -> UserListResult {
        
        let requestDTO = applicationFactory.makeListRequest()
        
        let dto: UserListResponseDTO = try await apiClient.request(
            UserEndpoint.list(requestDTO)
        )

        let domain = dto.toDomain()

        return UserListResult(
            users: domain.users,
            inviteUsers: domain.inviteUsers
        )
    }
    
    
    func update(siteId: String, userId: String, role: UserRole) async throws {
        let requestDTO = userRequestFactory.makeUpdateRequest(siteID: siteId, userID: userId, userRole: role)
        
        let _: ClientResponseDTO = try await apiClient.request(
            UserEndpoint.update(requestDTO)
        )
    }
    
    
    func delete(siteId: String, userId: String) async throws {
        let requestDTO = userRequestFactory.makeDeleteRequest(siteID: siteId, userID: userId)
        
        let _: ClientResponseDTO = try await apiClient.request(
            UserEndpoint.delete(requestDTO)
        )
    }
    
    func inviteResend(code: String) async throws {
        let requestDTO = userRequestFactory.makeInviteResendRequest(code: code)
        
        let _: ClientResponseDTO = try await apiClient.request(
            UserEndpoint.inviteResend(requestDTO)
        )
    }
    
    func inviteDelete(code: String) async throws {
        let requestDTO = userRequestFactory.makeInviteDeleteRequest(code: code)
        
        let _: ClientResponseDTO = try await apiClient.request(
            UserEndpoint.inviteDelete(requestDTO)
        )
    }
    
    func inviteUser(email: String, permission: UserPermission) async throws {
        let requestDTO = userRequestFactory.makeInviteUserRequest(email: email, permission: permission)
        
        let _: ClientResponseDTO = try await apiClient.request(
            UserEndpoint.inviteUser(requestDTO)
        )
    }
}
