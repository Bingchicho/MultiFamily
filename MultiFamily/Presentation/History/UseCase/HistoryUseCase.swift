//
//  HistoryUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

import Foundation

protocol HistoryUseCase {

    func fetch(
        id: String, timePoint: Int64
    ) async -> HistoryResult

}

final class HistoryUseCaseImpl: HistoryUseCase {

    private let repository: HistoryRepository

    init(repository: HistoryRepository) {
        self.repository = repository
    }

    func fetch(id: String, timePoint: Int64) async -> HistoryResult {

        do {

            let result = try await repository.fetch(
                id: id,
                timePoint: timePoint,
                maximum: 700
            )

            return .success(result)

        } catch {

            return .failure(L10n.Common.Error.network)

        }
    }
}

extension Date {

    var millisecondsSince1970: Int64 {
        Int64(timeIntervalSince1970 * 1000)
        
    }

}
