//
//  ForgotPasswordEndpoint.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/5.
//


enum ForgotPasswordEndpoint {
    static func sendCode(_ dto: ForgotPasswordSendCodeRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/forgot-password",
            method: .post,
            body: dto,
            requiresAuth: false
        )
    }
    
    static func resetPassword(_ dto: ForgotPasswordConfirmRequestDTO) -> APIRequest {
        APIRequest(
            host: AppEnvironment.apiHostname,
            version: AppEnvironment.authService,
            path: "/user/forgot-password",
            method: .post,
            body: dto,
            requiresAuth: false
        )
    }
    

    
}
