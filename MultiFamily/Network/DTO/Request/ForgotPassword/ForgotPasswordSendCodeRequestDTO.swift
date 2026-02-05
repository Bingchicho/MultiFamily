//
//  ForgotPasswordSendCodeRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//

struct ForgotPasswordLoginDTO: Encodable {
    let email: String
    let password: String?
}

struct ForgotPasswordRequestDTO: Encodable {

    let applicationID: String
    let clientToken: String

    let login: ForgotPasswordLoginDTO

    let ticket: String?
    let code: String?

    enum CodingKeys: String, CodingKey {
        case applicationID
        case clientToken
        case login
        case ticket
        case code
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(applicationID, forKey: .applicationID)
        try container.encode(clientToken, forKey: .clientToken)
        try container.encode(login, forKey: .login)

        // 👇 關鍵：只有有值才 encode
        if let ticket {
            try container.encode(ticket, forKey: .ticket)
        }

        if let code {
            try container.encode(code, forKey: .code)
        }
    }
}
