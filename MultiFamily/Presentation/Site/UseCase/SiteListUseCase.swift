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

protocol SiteListUseCase {
    func execute() async -> SiteListResult
    func setSiteSelection(_ site: Site)
}

final class SiteListUseCaseImpl: SiteListUseCase {

    

    private let repository: SiteListRepository
    private let siteSelectionStore = AppAssembler.siteSelectionStore

    init(repository: SiteListRepository) {
        self.repository = repository
    }

    func execute() async -> SiteListResult {

        let result: SiteListResult

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

        }
    }
    
    func setSiteSelection(_ site: Site) {
        siteSelectionStore.save(site)
    }
}
