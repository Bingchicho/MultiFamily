//
//  RegisterVerifyViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//

enum RegisterVerifyViewState {
    case idle
    case loading
    case error(String)
    case resendCooldown(remaining: Int)
    
    var isLoading: Bool {
         if case .loading = self { return true }
         return false
     }
}
