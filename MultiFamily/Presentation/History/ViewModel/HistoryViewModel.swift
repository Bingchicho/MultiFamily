//
//  HistoryViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

import Foundation

@MainActor
final class HistoryViewModel {

    private let useCase: HistoryUseCase

    private(set) var state: HistoryViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((HistoryViewState) -> Void)?

    private(set) var histories: [History] = []

    init(useCase: HistoryUseCase) {
        self.useCase = useCase
    }

    func load(id: String) {

        state = .loading

        Task {

            let result = await useCase.fetch(id: id, timePoint: Date().millisecondsSince1970)

            switch result {

            case .success(let histories):

                self.histories = histories

                state = .loaded(histories)

            case .failure(let message):

                state = .error(message)

            }
        }
    }

}
