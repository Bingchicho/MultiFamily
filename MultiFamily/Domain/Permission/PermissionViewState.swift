//
//  AuthorizedViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

enum PermissionViewState {

    case idle
    case loading
    case loaded([PermissionUser], [PermissionCard])
    case error(String)
}
