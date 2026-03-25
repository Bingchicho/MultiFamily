//
//  DetailUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

import MFRBleSDK
protocol DetailUseCase {
    
    var response: DetailResponseDTO? { get }

    func execute(thingName: String) async -> Result<Detail, Error>
    func delete(thingName: String) async -> Result<Void, Error>
    func remove(thingName: String) async -> Result<Void, Error>
    func jobSync(device: Device) async -> Result<Void, Error>
    func lockAction(device: Device) async -> Result<Bool, Error>
    func disconnect() async -> Result<Void, Error>
}


final class DetailUseCaseImpl: DetailUseCase {

    

    
  

    private let repository: DetailRepository
 
    
    var response: DetailResponseDTO?
    private let bleService: JobService
    private let lockUnlockService: LockUnlockService

    init(repository: DetailRepository, bleserivce: JobService, lockunlockservice: LockUnlockService) {
        self.repository = repository
        self.bleService = bleserivce
        self.lockUnlockService = lockunlockservice
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
                    do {
                        try await bleService.setupSetting(value: config)
                        try await repository.jobUpdate(jobId: job.jobID, status: .done)
                    } catch {
                        try await repository.jobUpdate(
                            jobId: job.jobID,
                            status: .error
                        )
                        throw error
                    }
                }
                
            }
            
            return .success(())
            
        } catch {
          
            return .failure(error)
            
        }
    }
    
    func lockAction(device: Device) async -> Result<Bool, any Error> {
        do {
            if let door = lockUnlockService.status?.lock {
                let lock: Bool = door == .lockedOrNotLinked ? false : true
                try await lockUnlockService.LockAction(lock: lock, device: device)
            } else {
                try await lockUnlockService.connection(device: device)
            }
            
            return .success(self.lockUnlockService.status?.lock == .lockedOrNotLinked)
        } catch {
            return .failure(error)
        }
      
    }
    
    func disconnect() async -> Result<Void, any Error> {
        do {

            try await lockUnlockService.disconnect()

            return .success(())

        } catch {

            return .failure(error)

        }
    }

}
