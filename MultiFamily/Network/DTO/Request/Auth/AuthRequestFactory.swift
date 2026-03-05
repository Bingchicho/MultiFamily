//
//  UserRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

protocol AuthRequestFactoryProtocol {
    func makeLoginRequest(email: String, password: String) -> AuthRequestDTO
    func makeTokenRequest() -> AuthRequestDTO

}

struct AuthRequestFactory: AuthRequestFactoryProtocol {

    

    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    private let tokenStore: TokenStore
    
    init(
        env: EnvironmentConfig,
        device: DeviceIdentifierProvider,
        tokenStore: TokenStore
    ) {
        self.env = env
        self.device = device
        self.tokenStore = tokenStore
    }

    func makeLoginRequest(
        email: String,
        password: String
    ) -> AuthRequestDTO {

        AuthRequestDTO(
            applicationID: env.applicationID,
            clientToken: device.clientToken,
            payload: .login(
                LoginPayloadDTO(
                    email: email,
                    password: password
                )
            )
        )
    }
    
    func makeTokenRequest() -> AuthRequestDTO {
        let refreshToken = tokenStore.refreshToken ?? "1234"
        return AuthRequestDTO(
            applicationID: env.applicationID,
            clientToken: device.clientToken,
            payload: .refreshToken(RefreshTokenPayloadDTO(refreshToken: refreshToken))
        )
    }
    
 
}
