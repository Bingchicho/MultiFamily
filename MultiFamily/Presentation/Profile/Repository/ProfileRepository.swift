//
//  ProfileRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

protocol ProfileRepository {

    func updateName(name: String, email: String) async throws
    func updatePassword(email: String, oldPassword: String, password: String) async throws
    func updateMobile(mobile: String, email: String) async throws
    func logout() async throws
    func deleteAccount() async throws
}

final class ProfileRepositoryImpl: ProfileRepository {

    

    private let apiClient: APIClient
    private let factory: ProfileRequestFactoryProtocol
    private let userStore: UserAttributeStore

    init(
        apiClient: APIClient,
        factory: ProfileRequestFactoryProtocol,
        userStore: UserAttributeStore
    ) {
        self.apiClient = apiClient
        self.factory = factory
        self.userStore = userStore
    }
    
    
    func updateName(name: String, email: String) async throws {
        let request = factory.makeNameRequest(name: name)
        let response: UpdateProfileResponseDTO = try await apiClient.request(
            ProfileEndpoint.update(request)
        )
        
        let profile = response.attribute.toDomain()

        userStore.save(profile,email: email)
    }
    
    func updatePassword(email: String, oldPassword: String, password: String) async throws {
        let request = factory.makePasswordRequest(email: email, oldPassword: oldPassword, password: password)
        let response: UpdateProfileResponseDTO = try await apiClient.request(
            ProfileEndpoint.update(request)
        )
        
        let profile = response.attribute.toDomain()

        userStore.save(profile,email: email)
    }

    func updateMobile(mobile: String, email: String) async throws {
        let request = factory.makeMobileRequest(mobile: mobile)
        let response: UpdateProfileResponseDTO = try await apiClient.request(
            ProfileEndpoint.update(request)
        )
        
        let profile = response.attribute.toDomain()

        userStore.save(profile,email: email)
    }
    
    
    func logout() async throws {
        let request = factory.makeLogoutRequest()
        let _: ClientResponseDTO = try await apiClient.request(
            ProfileEndpoint.logout(request)
        )
    }
    
    func deleteAccount() async throws {
        let request = factory.makeDeleteAccountRequest()
        let _: ClientResponseDTO = try await apiClient.request(
            ProfileEndpoint.deleteAccount(request)
        )
    }
   
}
