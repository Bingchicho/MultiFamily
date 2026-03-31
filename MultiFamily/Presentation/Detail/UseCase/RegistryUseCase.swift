//
//  RegistryUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

protocol RegistryUseCase {
    func execute(thingName: String, form: RegistryForm, device: Device) async -> Result<Void, Error>
}


final class RegistryUseCaseImpl: RegistryUseCase {

    
    private let repository: DetailRepository
    private let bleService: JobService
    
    init(repository: DetailRepository, bleserivce: JobService,) {
        self.repository = repository
        self.bleService = bleserivce
    }
    

    
    func execute(thingName: String, form: RegistryForm, device: Device) async -> Result<Void, any Error> {
        do {
            
            // TODO: 先 打blecommand
            try await bleService.connection(device: device)
            
            try await bleService.setupSetting(value: form)
            
            try await repository.updateRegistry(thingName: thingName, name: form.name, autoLockOn: form.isAutoLockOn, autoLockTime: form.autoLockDelay, beepOn: form.isBeepOn, power: form.txPower.rawValue, adv: form.adv.rawValue
            )
            
            return .success(())
            
        } catch {
            
            return .failure(error)
            
        }
    }
}
