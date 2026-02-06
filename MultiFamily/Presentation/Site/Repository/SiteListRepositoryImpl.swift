//
//  SiteListRepositoryImpl.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//


final class SiteListRepositoryImpl: SiteListRepository {

    


    private let apiClient: APIClient
    private let siteListRequestFactory: SiteListRequestFactoryProtocol
    

    init(
        apiClient: APIClient,
        siteListFactory: SiteListRequestFactoryProtocol,

    ) {
        self.apiClient = apiClient
        self.siteListRequestFactory = siteListFactory

    }
    
    func getList() async throws -> SiteListResult {
        do {
            let requestDTO: SiteListRequestDTO = siteListRequestFactory.makeSiteListRequest()
            
            let response: SiteListResponseDTO = try await apiClient.request(
                SiteEndpoint.getList(requestDTO)
            )
            
            let sites = response.sites.map { $0.toDomain() }
            
            return .success(sides: sites)
            
        } catch {
            return .failure(L10n.Common.Error.network)
        }
    }


    

}
