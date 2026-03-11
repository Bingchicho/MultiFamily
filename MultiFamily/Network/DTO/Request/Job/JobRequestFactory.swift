//
//  JobRequestFactory.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//


protocol JobRequestFactoryProtocol {
    
    func makeJobListGetRequest(
        thingName: String
    ) -> JobListGetRequestDTO
    
    func makeJobCreateRequest(
        thingName: String,
        siteID: String,
        action: JobActionDTO,
        payload: JobPayloadDTO
    ) -> JobCreateRequestDTO
    
    
    func makeJobUpdateRequest(
        jobID: String,
        status: JobStatusDTO
    ) -> JobUpdateRequestDTO
}

struct JobRequestFactory: JobRequestFactoryProtocol {

    
    
    
    
    
    
    
    private let env: EnvironmentConfig
    private let device: DeviceIdentifierProvider
    
    init(env: EnvironmentConfig, device: DeviceIdentifierProvider) {
        self.env = env
        self.device = device
    }
    
    func makeJobListGetRequest(thingName: String) -> JobListGetRequestDTO {
        JobListGetRequestDTO(applicationID: env.applicationID, thingName: thingName, all: false, clientToken: device.clientToken)
    }
    
    func makeJobCreateRequest(thingName: String, siteID: String, action: JobActionDTO, payload: JobPayloadDTO) -> JobCreateRequestDTO {
        JobCreateRequestDTO(applicationID: env.applicationID, thingName: thingName, siteID: siteID, action: action, payload: payload, clientToken: device.clientToken)
    }
    
    func makeJobUpdateRequest(jobID: String, status: JobStatusDTO) -> JobUpdateRequestDTO {
        JobUpdateRequestDTO(applicationID: env.applicationID, jobID: jobID, status: status, clientToken: device.clientToken)
    }
    
}
