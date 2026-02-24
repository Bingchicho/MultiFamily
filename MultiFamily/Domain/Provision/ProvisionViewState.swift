//
//  ProvisionViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

enum ProvisionViewState: Equatable {
    case idle
    case loading(String)      // 顯示「Provisioning...」「Connecting...」「Fetching...」
    case success
    case error(String)
}

