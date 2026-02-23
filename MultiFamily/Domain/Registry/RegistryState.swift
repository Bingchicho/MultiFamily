//
//  SettingState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

enum RegistryViewState: Equatable {
    case idle
    case editing(isSaveEnabled: Bool)
    case saving
    case success
    case error(message: String)
}


