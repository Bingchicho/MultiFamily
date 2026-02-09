//
//  FirstLaunchDetector.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

import Foundation

enum FirstLaunchDetector {

    private static let key = "hasLaunchedBefore"

    static func handleFirstLaunch() {

        let hasLaunchedBefore = UserDefaults.standard.bool(forKey: key)

        if !hasLaunchedBefore {

            // App reinstall → clear Keychain
            KeychainCleaner.clearAll()
            AppAssembler.siteSelectionStore.clear()
            AppAssembler.tokenStore.clear()
            AppAssembler.userAttributeStore.clear()
            

            UserDefaults.standard.set(true, forKey: key)
        }
    }
}
