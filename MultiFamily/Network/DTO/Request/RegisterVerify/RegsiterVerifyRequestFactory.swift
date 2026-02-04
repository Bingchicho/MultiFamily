//
//  RegsiterVerifyRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/4.
//


protocol RegsiterVerifyRequestFactoryProtocol {
    func makeRegisterVerifyRequest(ticket: String, code: String) -> RegisterVerifyRequestDTO
    
}

struct RegisterVerifyRequestFactory: RegsiterVerifyRequestFactoryProtocol {

    private let device: DeviceIdentifierProvider
    
    
    init(
        device: DeviceIdentifierProvider
    ) {
        self.device = device
    }
    
    
    func makeRegisterVerifyRequest(ticket: String, code: String) -> RegisterVerifyRequestDTO {
        RegisterVerifyRequestDTO(ticket: ticket, code: code, clientToken: device.clientToken)
    }
    
    
}
