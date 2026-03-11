//
//  AddRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/11.
//


protocol AddRepository {
   
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, remotePinCode: String, bt: DeviceAddBTRequestDTO, attributes: DeviceAddAttributesDTO) async throws
}


final class AddRepositoryImpl: AddRepository {

    private let apiClient: APIClient
    
    private let requestFactory: DeviceAddRequestFactoryProtocol


    init(apiClient: APIClient,  requestFactory: DeviceAddRequestFactoryProtocol) {
        self.apiClient = apiClient
        self.requestFactory = requestFactory
 
    }


    
    func submit(siteID: String, name: String, activeMode: String, model: String, isResident: Bool, deviceID: Int, remotePinCode: String, bt: DeviceAddBTRequestDTO, attributes: DeviceAddAttributesDTO) async throws  {
        let requestDTO = requestFactory.makeDeviceAddRequest(siteID: siteID, name: name, activeMode: activeMode, model: model, isResident: isResident, deviceID: deviceID, remotePinCode: remotePinCode, bt: bt, attributes: attributes)
        
        let _: DeviceAddResponseDTO =
        try await apiClient.request(
            AddEndpoint.deviceAdd(requestDTO)
        )
        
       
    }
}
