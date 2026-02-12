//
//  PermissionUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

import Foundation
protocol PermissionUseCase {

    func execute(
        thingName: String
    ) async -> PermissionResult
}

final class PermissionUseCaseImpl: PermissionUseCase {

    private let repository: PermissionRepository

    init(repository: PermissionRepository) {
        self.repository = repository
    }

    func execute(
        thingName: String
    ) async -> PermissionResult {

        do {

            let response = try await repository.fetchPermission(
                thingName: thingName
            )

            let users = response.users
                .map { $0.toDomain() }
                .sorted {
                    $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }

            let cards = response.cards
                .map { $0.toDomain() }
                .sorted {
                    $0.id < $1.id
                }

            return .success(
                users: users,
                cards: cards
            )

        } catch {
      
            return .failure(L10n.Common.Error.network)
        }
    }
}
