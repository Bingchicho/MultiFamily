//
//  DefaultDeviceIdentifierProvider.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import Foundation
final class DefaultDeviceIdentifierProvider: DeviceIdentifierProvider {

    private let secureStore: SecureStore
    private let key = "com.multifamily.deviceIdentifier"

    init(secureStore: SecureStore = KeychainService()) {
        self.secureStore = secureStore
    }

    var clientToken: String {
        if let saved = load() {
            return saved
        }

        let newToken = UUID().uuidString
        save(newToken)
        return newToken
    }

    private func save(_ value: String) {
        secureStore.save(value, key: key)
    }

    private func load() -> String? {
        secureStore.load(key: key)
    }
}
