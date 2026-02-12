//
//  PermissionViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

@MainActor
final class PermissionViewModel {

    private(set) var state: PermissionViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((PermissionViewState) -> Void)?

    private(set) var users: [PermissionUser] = []
    private(set) var cards: [PermissionCard] = []

    private let useCase: PermissionUseCase

    init(useCase: PermissionUseCase) {
        self.useCase = useCase
    }

    func load(thingName: String) {

        state = .loading

        Task {

            let result = await useCase.execute(
                thingName: thingName
            )

            handle(result)
        }
    }

    private func handle(
        _ result: PermissionResult
    ) {

        switch result {

        case .success(let users, let cards):

            self.users = users
            self.cards = cards.filter { $0.activate == false }

            state = .loaded(self.users, self.cards)

        case .failure(let message):

            state = .error(message)
        }
    }

}
