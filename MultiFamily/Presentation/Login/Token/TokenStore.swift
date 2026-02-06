//
//  TokenStore.swift
//  MultiFamily
//
//  Created by Sunion on 2026/1/29.
//

protocol TokenStore {
    var accessToken: String? { get set }
    var refreshToken: String? { get set }

    func clear()
}
