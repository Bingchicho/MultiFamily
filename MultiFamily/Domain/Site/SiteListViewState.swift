//
//  SiteListViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

enum SiteListViewState {
    case idle
    case loading
    case loaded([Site])
    case error(String)
}
