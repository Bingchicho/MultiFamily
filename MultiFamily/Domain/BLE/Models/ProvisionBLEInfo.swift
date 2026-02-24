//
//  ProvisionBLEInfo.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import Foundation


public struct ProvisionBLEInfo: Equatable, Sendable {
    public let uuid: String
    public let key: String
    public let token: String
    public let iv: String

    public init(uuid: String, key: String, token: String, iv: String) {
        self.uuid = uuid
        self.key = key
        self.token = token
        self.iv = iv
    }
}
