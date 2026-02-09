//
//  KeychainCleaner.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

import Security

enum KeychainCleaner {

    static func clearAll() {

        let secClasses = [
            kSecClassGenericPassword,
            kSecClassInternetPassword,
            kSecClassCertificate,
            kSecClassKey,
            kSecClassIdentity
        ]

        for secClass in secClasses {

            let query: [String: Any] = [
                kSecClass as String: secClass
            ]

            SecItemDelete(query as CFDictionary)
        }
    }
}
