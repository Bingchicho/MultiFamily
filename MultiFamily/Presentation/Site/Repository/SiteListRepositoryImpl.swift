//
//  SiteListRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//


import Foundation
final class SiteRepositoryImpl: SiteRepository {


    private let apiClient: APIClient
    private let siteRequestFactory: SiteRequestFactoryProtocol
    

    init(
        apiClient: APIClient,
        siteListFactory: SiteRequestFactoryProtocol,

    ) {
        self.apiClient = apiClient
        self.siteRequestFactory = siteListFactory

    }
    
    func getList() async throws -> SiteResult {
        do {
            let requestDTO: SiteListRequestDTO = siteRequestFactory.makeSiteListRequest()
            
            let response: SiteListResponseDTO = try await apiClient.request(
                SiteEndpoint.list(requestDTO)
            )
            
            let sites = response.sites
                .map { $0.toDomain() }
                .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
            
            return .success(sides: sites)
            
        } catch {
            return .failure(L10n.Common.Error.network)
        }
    }

    func create(_ name: String) async throws -> SiteResult {
        do {
            let requestDTO: SiteCreateRequestDTO = siteRequestFactory.makeSiteCreateRequest(name: name)
            
            let response: SiteCreateResponseDTO = try await apiClient.request(
                SiteEndpoint.create(requestDTO)
            )
            
            return .optionSuccess
            
        } catch {
            return .failure(L10n.Common.Error.network)
        }
    }
    
    func update(_ id: String, _ name: String) async throws -> SiteResult {
        do {
            let requestDTO: SiteUpdateRequestDTO = siteRequestFactory.makeSiteUpdateRequest(id, name: name)
            
            let response: SiteUpdateResponseDTO = try await apiClient.request(
                SiteEndpoint.update(requestDTO)
            )
            
            return .optionSuccess
            
        } catch {
            return .failure(L10n.Common.Error.network)
        }
    }
    
    func delete(_ id: String) async throws -> SiteResult {
        do {
            let requestDTO: SiteDeleteRequestDTO = siteRequestFactory.makeSiteDeleteRequest(id)
            
            let response: SiteDeleteResponseDTO = try await apiClient.request(
                SiteEndpoint.delete(requestDTO)
            )
            
            return .optionSuccess
            
        } catch {
            return .failure(L10n.Common.Error.network)
        }
    }
    
    

}
