//
//  DetailViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

@MainActor
final class DetailViewModel {

    private(set) var state: DetailViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((DetailViewState) -> Void)?

    private let useCase: DetailUseCase

    init(useCase: DetailUseCase) {
        self.useCase = useCase
    }

    func load(thingName: String) {

        state = .loading

        Task {

            let result =
                await useCase.execute(
                    thingName: thingName
                )

            switch result {

            case .success(let detail):
                state = .loaded(detail)

            case .failure(let error):
                state = .error(L10n.Common.Error.network)

            }

        }

    }

}
