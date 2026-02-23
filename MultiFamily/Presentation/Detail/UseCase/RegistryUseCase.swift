//
//  RegistryUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

protocol RegistryUseCase {
    func execute(thingName: String, form: RegistryForm) async -> Result<Void, Error>
}


final class RegistryUseCaseImpl: RegistryUseCase {

    
    private let repository: DetailRepository
    
    init(repository: DetailRepository) {
        self.repository = repository
    }
    

    
    func execute(thingName: String, form: RegistryForm) async -> Result<Void, any Error> {
        do {
            
       
            try await repository.updateRegistry(thingName: thingName, name: form.name, autoLockOn: form.isAutoLockOn, autoLockTime: form.autoLockDelay, beepOn: form.isBeepOn, power: form.txPower.rawValue, adv: form.adv.rawValue
            )
            
            return .success(())
            
        } catch {
            
            return .failure(error)
            
        }
    }
}
