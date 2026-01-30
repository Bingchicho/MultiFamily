//
//  AppEnvironment.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import Foundation

enum AppEnvironment {
    
    static func value(for key: String) -> String {
        guard
            let value = Bundle.main.object(forInfoDictionaryKey: key) as? String,
            !value.isEmpty
        else {
            fatalError("❌ Missing \(key) in Info.plist")
        }
        return value
    }
    
    static let brand = value(for: "APP_BRAND")
    
    static let apiHostname = "https://" + value(for: "API_HOSTNAME")
    static let authService = value(for: "AUTH_SERVICE")
    static let envName = value(for: "ENV_NAME")
    static let apiKey = value(for: "API_KEY")
    static let apiApplicationId = value(for: "API_APPLICATION_ID")
    
    static let mqttHostname = value(for: "MQTT_HOSTNAME")
}
