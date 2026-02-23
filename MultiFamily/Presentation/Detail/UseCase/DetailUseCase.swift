//
//  DetailUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

protocol DetailUseCase {
    
    var response: DetailResponseDTO? { get }

    func execute(thingName: String) async -> Result<Detail, Error>
    func remove(thingName: String) async -> Result<Void, Error>

}


final class DetailUseCaseImpl: DetailUseCase {


    private let repository: DetailRepository
    
    var response: DetailResponseDTO?

    init(repository: DetailRepository) {
        self.repository = repository
    }

    func execute(thingName: String) async -> Result<Detail, Error> {

        do {

            let detail =
                try await repository.fetchRegistry(
                    thingName: thingName
                )
            response = detail
            return .success(detail.toDomain())

        } catch {

            return .failure(error)

        }

    }
    
    func remove(thingName: String) async -> Result<Void, any Error> {
        do {

            try await repository.deleteDevice(
                    thingName: thingName
                )

            return .success(())

        } catch {

            return .failure(error)

        }
    }

}
