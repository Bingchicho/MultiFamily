//
//  SiteSelectorViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//
@MainActor
final class SiteListViewModel {

    private let useCase: SiteListUseCase

    init(useCase: SiteListUseCase) {
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
}
