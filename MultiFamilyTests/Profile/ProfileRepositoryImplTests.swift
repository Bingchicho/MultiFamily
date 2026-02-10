//
//  ProfileRepositoryImplTests.swift
//  MultiFamilyTests
//
//  Created by Sunion on 2026/2/10.
//

import XCTest
import MultiFamily

final class ProfileRepositoryImplTests: XCTestCase {

    private var apiClient: MockProfileAPIClient!
    private var factory: FakeProfileRequestFactory!
    private var userStore: FakeUserAttributeStore!
    private var sut: ProfileRepositoryImpl!

    override func setUp() {
        super.setUp()

        apiClient = MockProfileAPIClient()
        factory = FakeProfileRequestFactory()
        userStore = FakeUserAttributeStore()

        sut = ProfileRepositoryImpl(
            apiClient: apiClient,
            factory: factory,
            userStore: userStore
        )
    }

    override func tearDown() {
        apiClient = nil
        factory = nil
        userStore = nil
        sut = nil
        super.tearDown()
    }

    // MARK: - updateName

    func test_updateName_savesProfile() async throws {


        // when
        try await sut.updateName(
            name: "John",
            email: "test@email.com"
        )

        // then
        XCTAssertEqual(apiClient.calledEndpoint, .update)
        XCTAssertEqual(userStore.currentEmail, "test@email.com")
        XCTAssertEqual(userStore.currentUser?.username, "John")
    }

    // MARK: - updatePassword

    func test_updatePassword_savesProfile() async throws {

    

        try await sut.updatePassword(
            email: "test@email.com",
            oldPassword: "old",
            password: "new"
        )

        XCTAssertEqual(apiClient.calledEndpoint, .update)
    
    }

    // MARK: - updateMobile

    func test_updateMobile_savesProfile() async throws {

  

        try await sut.updateMobile(
            mobile: "0912345678",
            email: "test@email.com"
        )

        XCTAssertEqual(apiClient.calledEndpoint, .update)
        XCTAssertEqual(userStore.currentUser?.phone, "0912345678")
    }

    // MARK: - logout

    func test_logout_callsLogoutEndpoint() async throws {

    

        try await sut.logout()

        XCTAssertEqual(apiClient.calledEndpoint, .logout)
    }

    // MARK: - deleteAccount

    func test_deleteAccount_callsDeleteEndpoint() async throws {

       

        try await sut.deleteAccount()

        XCTAssertEqual(apiClient.calledEndpoint, .delete)
    }
}
final class MockProfileAPIClient: APIClient {

    enum CalledEndpoint {
        case update
        case logout
        case delete
    }

    var calledEndpoint: CalledEndpoint?

    var updateResponse: UpdateProfileResponseDTO!
    var clientResponse: ClientResponseDTO!

    func request<T>(_ request: APIRequest) async throws -> T where T : Decodable {

        if request.path == "/user/update" {
            calledEndpoint = .update
            
            if let updateResponse {
                return updateResponse as! T
            }
            
         
            // default mock response to prevent SIGABRT
            let mock = UpdateProfileResponseDTO(
                attribute: AttributeDTO(
                    preferredUsername: "John",
                    preferredLanguage: nil,
                    phone: "0912345678",
                    country: nil,
                    debugLog: nil,
                    permission: nil
                ),
            
                clientToken: "TEST"
            )
            return mock as! T
        }

        if request.path == "/user/logout" {
            calledEndpoint = .logout
            
            if let clientResponse {
                return clientResponse as! T
            }
            
            // default mock response to prevent SIGABRT
            let mock = ClientResponseDTO(clientToken: "TEST")
            return mock as! T
        }

        if request.path == "/user/delete" {
            calledEndpoint = .delete
            
            if let clientResponse {
                return clientResponse as! T
            }
            
            // default mock response to prevent SIGABRT
            let mock = ClientResponseDTO(clientToken: "TEST")
            return mock as! T
        }

        fatalError("Unknown endpoint path: \(request.path)")
    }
}

final class FakeProfileRequestFactory: ProfileRequestFactoryProtocol {

    func makeNameRequest(name: String) -> UpdateProfileRequestDTO {
        UpdateProfileRequestDTO(applicationID: "TEST", attribute: AttributeDTO(preferredUsername: name, preferredLanguage: nil, phone: nil, country: nil, debugLog: nil, permission: nil), login: nil, clientToken: "TEST")
    }

    func makePasswordRequest(
        email: String,
        oldPassword: String,
        password: String
    ) -> UpdateProfileRequestDTO {
     
        UpdateProfileRequestDTO(applicationID: "TEST", attribute: nil, login: UpdateLoginDTO(email: email, oldPassword: oldPassword, password: password), clientToken: "TEST")
    }

    func makeMobileRequest(mobile: String) -> UpdateProfileRequestDTO {

        UpdateProfileRequestDTO(applicationID: "TEST", attribute: AttributeDTO(preferredUsername: "TEST", preferredLanguage: nil, phone: mobile, country: nil, debugLog: nil, permission: nil), login: nil, clientToken: "TEST")
    }

    func makeLogoutRequest() -> LogoutRequestDTO {
        LogoutRequestDTO(applicationID: "TEST", logoutAllDevice: false, clientToken: "TEST")
    }

    func makeDeleteAccountRequest() -> applicationIDRequestDTO {
        applicationIDRequestDTO(applicationID: "TEST", clientToken: "TEST")
    }
}
