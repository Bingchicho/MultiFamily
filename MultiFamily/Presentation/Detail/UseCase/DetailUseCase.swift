//
//  DetailUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

protocol DetailUseCase {

    func execute(thingName: String) async -> Result<Detail, Error>

}


final class DetailUseCaseImpl: DetailUseCase {

    private let repository: DetailRepository

    init(repository: DetailRepository) {
        self.repository = repository
    }

    func execute(thingName: String) async -> Result<Detail, Error> {

        do {

            let detail =
                try await repository.fetchRegistry(
                    thingName: thingName
                )

            return .success(detail)

        } catch {

            return .failure(error)

        }

    }

}
