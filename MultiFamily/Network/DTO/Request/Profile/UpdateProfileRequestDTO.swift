//
//  UpdateProfileRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

struct UpdateProfileRequestDTO: Encodable {

    let applicationID: String
    let attribute: AttributeDTO?
    let login: UpdateLoginDTO?
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case applicationID
        case attribute
        case login
        case clientToken
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(applicationID, forKey: .applicationID)

        if let attribute {
            try container.encode(attribute, forKey: .attribute)
        }

        if let login {
            try container.encode(login, forKey: .login)
        }

        try container.encode(clientToken, forKey: .clientToken)
    }
}

struct UpdateLoginDTO: Encodable {

    let email: String?
    let oldPassword: String?
    let password: String?

    enum CodingKeys: String, CodingKey {
        case email
        case oldPassword
        case password
    }

    func encode(to encoder: Encoder) throws {

        var container = encoder.container(keyedBy: CodingKeys.self)

        if let email {
            try container.encode(email, forKey: .email)
        }

        if let oldPassword {
            try container.encode(oldPassword, forKey: .oldPassword)
        }

        if let password {
            try container.encode(password, forKey: .password)
        }
    }
}
