//
//  SiteListRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

protocol SiteRepository {
    func getList() async throws -> SiteResult
    func create(_ name: String) async throws  -> SiteResult
    func update(_ id: String, _ name: String) async throws  -> SiteResult
    func delete(_ id: String) async throws  -> SiteResult
}
