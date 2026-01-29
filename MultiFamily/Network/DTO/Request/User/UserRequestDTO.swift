//
//  UserRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

struct UserRequestDTO: Encodable {

     let applicationID: String 
     let clientToken: String
    let payload: Payload

    enum Payload {
        case login(LoginPayloadDTO)
        case refreshToken(RefreshTokenPayloadDTO)
    }
    
    init(
        applicationID: String,
        clientToken: String,
        payload: Payload
    ) {
        self.applicationID = applicationID
        self.clientToken = clientToken
        self.payload = payload
    }

}

extension UserRequestDTO {

    enum CodingKeys: String, CodingKey {
        case applicationID
        case login
        case token
        case clientToken
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(applicationID, forKey: .applicationID)
        try container.encode(clientToken, forKey: .clientToken)

        switch payload {
        case .login(let loginPayload):
            try container.encode(loginPayload, forKey: .login)

        case .refreshToken(let tokenPayload):
            try container.encode(tokenPayload, forKey: .token)
        }
    }
}
