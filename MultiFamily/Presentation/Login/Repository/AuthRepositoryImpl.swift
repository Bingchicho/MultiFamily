final class AuthRepositoryImpl: AuthRepository {

    

    private let apiClient: APIClient
    private var tokenStore: TokenStore
    private let userRequestFactory: AuthRequestFactoryProtocol
    private let userAttributeStore: UserAttributeStore

    init(
        apiClient: APIClient,
        tokenStore: TokenStore,
        userRequestFactory: AuthRequestFactoryProtocol,
        userAttribute: UserAttributeStore
    ) {
        self.apiClient = apiClient
        self.tokenStore = tokenStore
        self.userRequestFactory = userRequestFactory
        self.userAttributeStore = userAttribute
    }

    // MARK: - Login

    func login(email: String, password: String) async throws {

        let requestDTO = userRequestFactory.makeLoginRequest(
            email: email,
            password: password
        )

        let response: AuthResponseDTO = try await apiClient.request(
            AuthEndpoint.login(requestDTO)
        )

        saveAuth(from: response)
    }

    // MARK: - Refresh Token

    func refreshIfNeeded() async throws {

        guard tokenStore.refreshToken != nil else {
            throw APIClientError.invalidResponse
        }

        let requestDTO = userRequestFactory.makeTokenRequest()

        let response: AuthResponseDTO = try await apiClient.request(
            AuthEndpoint.refresh(requestDTO)
        )

        saveAuth(from: response)
    }

    // MARK: - Private

    /// Centralized auth persistence to avoid duplicated logic
    private func saveAuth(from response: AuthResponseDTO) {

        let token = response.toDomain()

        tokenStore.accessToken = token.accessToken
        tokenStore.refreshToken = token.refreshToken

        var attribute = response.attribute.toDomain()
        attribute.identityID = response.identityID
        userAttributeStore.save(attribute, email: response.email)
    }
    
    
}
