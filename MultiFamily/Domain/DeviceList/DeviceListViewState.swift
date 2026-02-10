//
//  DeviceListViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

enum DeviceListViewState {

    case idle
    case loading
    case loaded([Device])
    case error(String)
}
