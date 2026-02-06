//
//  SiteListRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

protocol SiteListRepository {
    func getList() async throws -> SiteListResult

}
