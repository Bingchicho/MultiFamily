//
//  HistoryRepository.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

protocol HistoryRepository {

    func fetch(
        id: String,
        timePoint: Int64,
        maximum: Int
    ) async throws -> [History]

}


final class HistoryRepositoryImpl: HistoryRepository {

    private let apiClient: APIClient
    private let factory: HistoryRequestFactoryProtocol

    init(
        apiClient: APIClient,
        factory: HistoryRequestFactoryProtocol
    ) {
        self.apiClient = apiClient
        self.factory = factory
    }

    func fetch(
        id: String,
        timePoint: Int64,
        maximum: Int
    ) async throws -> [History] {

        let dto = factory.makeHistoryRequest(
            id: id,
            timePoint: timePoint,
            maximum: maximum
        )

        let request = HistoryEndpoint.history(dto)

        let response: HistoryResponseDTO = try await apiClient.request(request)

        return response.toDomain()
    }
}
