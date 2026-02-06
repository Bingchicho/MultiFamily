final class UserRepositoryImpl: UserRepository {

    private let apiClient: APIClient
    private var tokenStore: TokenStore
    private let userRequestFactory: UserRequestFactoryProtocol
    private let userAttributeStore: UserAttributeStore

    init(
        apiClient: APIClient,
        tokenStore: TokenStore,
        userRequestFactory: UserRequestFactoryProtocol,
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

        let response: UserResponseDTO = try await apiClient.request(
            UserEndpoint.login(requestDTO)
        )

        saveAuth(from: response)
    }

    // MARK: - Refresh Token

    func refreshIfNeeded() async throws {

        guard tokenStore.refreshToken != nil else {
            throw APIClientError.invalidResponse
        }

        let requestDTO = userRequestFactory.makeTokenRequest()

        let response: UserResponseDTO = try await apiClient.request(
            UserEndpoint.refresh(requestDTO)
        )

        saveAuth(from: response)
    }

    // MARK: - Private

    /// Centralized auth persistence to avoid duplicated logic
    private func saveAuth(from response: UserResponseDTO) {

        let token = response.toDomain()

        tokenStore.accessToken = token.accessToken
        tokenStore.refreshToken = token.refreshToken

        let attribute = response.attribute.toDomain()
        userAttributeStore.save(attribute)
    }
}
