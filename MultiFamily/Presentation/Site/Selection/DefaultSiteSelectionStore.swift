//
//  DefaultSiteSelectionStore.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

protocol SiteSelectionStore {
    var currentSite: Site? { get }
    func save(_ site: Site)
    func clear()
}

final class DefaultSiteSelectionStore: SiteSelectionStore {
    
    static let shared = DefaultSiteSelectionStore()

    private(set) var currentSite: Site?

    func save(_ site: Site) {
        currentSite = site
    }

    func clear() {
        currentSite = nil
    }
}
