//
//  UserViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/9.
//

// MARK: - ViewState

enum UserViewState: Equatable {
    case idle
    case loading
    case loaded
    case option
    case error(String)
}
