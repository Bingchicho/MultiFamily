//
//  HistoryViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

enum HistoryViewState {

    case idle
    case loading
    case loaded([History])
    case error(String)

}
