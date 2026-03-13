//
//  DetailUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

protocol DetailUseCase {
    
    var response: DetailResponseDTO? { get }

    func execute(thingName: String) async -> Result<Detail, Error>
    func delete(thingName: String) async -> Result<Void, Error>
    func remove(thingName: String) async -> Result<Void, Error>
    func jobSync(device: Device) async -> Result<Void, Error>
}


final class DetailUseCaseImpl: DetailUseCase {
  
    


    private let repository: DetailRepository
 
    
    var response: DetailResponseDTO?
    private let bleService: JobService

    init(repository: DetailRepository, bleserivce: JobService) {
        self.repository = repository
        self.bleService = bleserivce
    }

    func execute(thingName: String) async -> Result<Detail, Error> {

        do {

            let detail =
                try await repository.fetchRegistry(
                    thingName: thingName
                )
            response = detail
            return .success(detail.toDomain())

        } catch {

            return .failure(error)

        }

    }
    
    func delete(thingName: String) async -> Result<Void, any Error> {
        do {

            try await repository.deleteDevice(
                    thingName: thingName
                )

            return .success(())

        } catch {

            return .failure(error)

        }
    }
    
    func remove(thingName: String) async -> Result<Void, any Error> {
        do {

            try await repository.removeDevice(
                    thingName: thingName
                )

            return .success(())

        } catch {

            return .failure(error)

        }
    }
    
    
    func jobSync(device: Device) async -> Result<Void, any Error> {
        do {
            
            let list =  try await repository.jobList(thingName: device.thingName)
            
            guard !list.isEmpty else {
                return .success(())
            }
            
            try await bleService.connection(device: device)
            
            for job in list {
//                if let config = job.setting,
//                   job.payloadVersion == bleService.version {
//                    try await bleService.setupSetting(value: config)
//                    try await repository.jobUpdate(jobId: job.jobID)
//                }
                
                if let config = job.setting {
                    try await bleService.setupSetting(value: config)
                    try await repository.jobUpdate(jobId: job.jobID)
                }
                
            }
            
            return .success(())
            
        } catch {
            
            return .failure(error)
            
        }
    }

}
