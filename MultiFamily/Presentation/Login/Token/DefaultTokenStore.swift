//
//  DefaultTokenStore.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//
import Security

final class DefaultTokenStore: TokenStore {
    
    static let shared = DefaultTokenStore()
    
    private let secureStore: SecureStore
    
    private init(secureStore: SecureStore = KeychainService()) {
        self.secureStore = secureStore
    }
    
    var accessToken: String? {
        get { secureStore.load(key: "access_token") }
        set {
            if let value = newValue {
                secureStore.save(value, key: "access_token")
            } else {
                secureStore.delete(key: "access_token")
            }
        }
    }
    
    var refreshToken: String? {
        get { secureStore.load(key: "refresh_token") }
        set {
            if let value = newValue {
                secureStore.save(value, key: "refresh_token")
            } else {
                secureStore.delete(key: "refresh_token")
            }
        }
    }
    
    func clear() {
        accessToken = nil
        refreshToken = nil
    }
}
