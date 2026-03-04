//
//  SiteSelectorViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//
@MainActor
final class SiteListViewModel {

    private let useCase: SiteUseCase

    init(useCase: SiteUseCase) {
        self.useCase = useCase
    }

    private(set) var state: SiteListViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((SiteListViewState) -> Void)?

    private var sites: [Site] = []

    func loadSites() {

        state = .loading

        Task {
            let result = await useCase.execute()

            switch result {

            case .success(let sites):

                self.sites = sites
                self.state = .loaded(sites)

            case .failure(let message):

                self.state = .error(message)
            case .optionSuccess:
                break
            }
        }
    }

    func site(at index: Int) -> Site {
        sites[index]
    }

    var count: Int {
        sites.count
    }
    
    func setSelectedSite(_ site: Site) {
        useCase.setSiteSelection(site)
    }
    
    func createSite(name: String) {
        state = .loading

        Task {
            let result = await useCase.create(name)

            switch result {

            case .success(let sites):

              break

            case .failure(let message):

                self.state = .error(message)
            case .optionSuccess:
                self.loadSites()
            }
        }
    }
    
    func editSite(id: String, name: String) {
        state = .loading

        Task {
            let result = await useCase.edit(id: id, name)

            switch result {

            case .success(let sites):

              break

            case .failure(let message):

                self.state = .error(message)
            case .optionSuccess:
                self.loadSites()
            }
        }
    }
    
    func deleteSite(id: String) {
        state = .loading

        Task {
            let result = await useCase.delete(id)

            switch result {

            case .success(let sites):

              break

            case .failure(let message):

                self.state = .error(message)
            case .optionSuccess:
                self.loadSites()
            }
        }
    }
}
