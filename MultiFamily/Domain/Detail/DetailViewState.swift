//
//  DeviceDetailViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

enum DetailViewState {

    case idle
    case loading
    case loaded(response: DetailResponseDTO?)
    case deleted
    case synced
    case error(String)
    case syncFailure(String)
    case lockStatus(Bool?) // true = lock, false = unlock, nil = unknow
    case disconnect
}
