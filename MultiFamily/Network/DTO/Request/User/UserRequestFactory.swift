//
//  UserRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

struct UserRequestFactory {

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
    ) -> UserRequestDTO {

        UserRequestDTO(
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
    
    func makeTokenRequest() -> UserRequestDTO {
        let refreshToken = tokenStore.refreshToken ?? "1234"
        return UserRequestDTO(
            applicationID: env.applicationID,
            clientToken: device.clientToken,
            payload: .refreshToken(RefreshTokenPayloadDTO(refreshToken: refreshToken))
        )
    }
}
