//
//  KeychainServiceTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//
import XCTest
import MultiFamily

final class FakeSecureStore: SecureStore {
    private var storage: [String: String] = [:]

    func save(_ value: String, key: String) {
        storage[key] = value
    }

    func load(key: String) -> String? {
        storage[key]
    }

    func delete(key: String) {
        storage.removeValue(forKey: key)
    }
}

final class KeychainServiceTests: XCTestCase {
    
    func test_device_identifier_persists_value() {
        let fakeStore = FakeSecureStore()
        let provider = DefaultDeviceIdentifierProvider(secureStore: fakeStore)
        let first = provider.clientToken
        let second = provider.clientToken

        XCTAssertEqual(first, second)
    }
}
