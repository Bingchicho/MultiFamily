//
//  SiteListUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

//
//  SiteListUseCase.swift
//  MultiFamily
//

import Foundation

protocol SiteUseCase {
    func execute() async -> SiteResult
    func setSiteSelection(_ site: Site)
    func create(_ name: String) async -> SiteResult
    func edit(id: String, _ name: String) async -> SiteResult
    func delete(_ id: String) async -> SiteResult
}

final class SiteListUseCaseImpl: SiteUseCase {


    private let repository: SiteRepository
    private let siteSelectionStore = AppAssembler.siteSelectionStore

    init(repository: SiteRepository) {
        self.repository = repository
    }

    func execute() async -> SiteResult {

        let result: SiteResult

        do {
            result = try await repository.getList()
        } catch {
            return .failure(error.localizedDescription)
        }

        switch result {

        case .success(let sites):

            return .success(sides: sites)

        case .failure(let message):

            return .failure(message)

        case .optionSuccess:
            return .optionSuccess
        }
    }
    
    func setSiteSelection(_ site: Site) {
        siteSelectionStore.save(site)
    }
    
    func create(_ name: String) async -> SiteResult {
        let result: SiteResult
        
        do {
            result = try await repository.create(name)
        } catch {
            return .failure(error.localizedDescription)
        }
        
        switch result {
            
        case .success(_):

            return .success(sides: [])

        case .failure(let message):

            return .failure(message)

        case .optionSuccess:
            return .optionSuccess
        }
    }
    func edit(id: String, _ name: String) async -> SiteResult {
        let result: SiteResult
        
        do {
            result = try await repository.update(id, name)
        } catch {
            return .failure(error.localizedDescription)
        }
        
        switch result {
            
        case .success(_):

            return .success(sides: [])

        case .failure(let message):

            return .failure(message)

        case .optionSuccess:
            return .optionSuccess
        }
    }
    
    func delete(_ id: String) async -> SiteResult {
        let result: SiteResult
        
        do {
            result = try await repository.delete(id)
        } catch {
            return .failure(error.localizedDescription)
        }
        
        switch result {
            
        case .success(_):

            return .success(sides: [])

        case .failure(let message):

            return .failure(message)

        case .optionSuccess:
            return .optionSuccess
        }
    }
}
