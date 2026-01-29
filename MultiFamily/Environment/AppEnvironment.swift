//
//  AppEnvironment.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import Foundation

enum AppEnvironment {
    static let apiHostname =
        Bundle.main.infoDictionary?["API_HOSTNAME"] as? String ?? ""

    static let authService =
        Bundle.main.infoDictionary?["AUTH_SERVICE"] as? String ?? ""

    static let envName =
        Bundle.main.infoDictionary?["ENV_NAME"] as? String ?? ""

    static let brand =
        Bundle.main.infoDictionary?["APP_BRAND"] as? String ?? ""
}
