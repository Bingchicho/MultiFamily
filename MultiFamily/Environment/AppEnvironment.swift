//
//  AppEnvironment.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

import Foundation

enum AppEnvironment {
    
    private static func value(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as? String ?? ""
    }
    
    static let brand = value(for: "APP_BRAND")
    
    static let apiHostname = value(for: "API_HOSTNAME")
    static let authService = value(for: "AUTH_SERVICE")
    static let envName = value(for: "ENV_NAME")
    static let apiKey = value(for: "API_KEY")
    static let apiApplicationId = value(for: "API_APPLICATION_ID")
    
    static let mqttHostname = value(for: "MQTT_HOSTNAME")
}
