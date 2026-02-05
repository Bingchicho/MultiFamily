//
//  ForgotPasswordViewState.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//

enum ForgotPasswordViewState {
    case idle
    case loading
    case sendedCode(email: String)
    case codeSent(remaining: Int?)
    case error(String)
}
