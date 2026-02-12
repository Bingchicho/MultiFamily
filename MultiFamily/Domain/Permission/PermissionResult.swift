//
//  PermissionResult.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

enum PermissionResult {

    case success(
        users: [PermissionUser],
        cards: [PermissionCard]
    )

    case failure(String)
}
