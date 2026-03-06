//
//  UserViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/6.
//

import Foundation

@MainActor
final class UserViewModel {

    private(set) var state: UserViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((UserViewState) -> Void)?

    private let useCase: UserUseCase
    private(set) var sections: [UserSection] = []

    init(useCase: UserUseCase) {
        self.useCase = useCase
    }

    func load() {
        state = .loading

        Task {
            let result = await useCase.execute()

            switch result {

            case .success(let users, let inviteUsers):
                sections = [
                    .inviteUsers(inviteUsers),
                    .users(users)
                ]
                state = .loaded

            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                state = .option
            }
        }
    }

    func showInviteOption() {
        state = .option
    }

    func update(siteId: String, userId: String, role: UserRole) {
        state = .loading

        Task {
            let result = await useCase.update(siteId: siteId, userId: userId, role: role)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load()
            }
        }
    }

    func delete(siteId: String, userId: String) {
        state = .loading

        Task {
            let result = await useCase.delete(siteId: siteId, userId: userId)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load()
            }
        }
    }

    func inviteResend(code: String) {
        state = .loading

        Task {
            let result = await useCase.inviteResend(code: code)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load()
            }
        }
    }

    func inviteDelete(code: String) {
        state = .loading

        Task {
            let result = await useCase.inviteDelete(code: code)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load()
            }
        }
    }

    func inviteUser(email: String, permission: UserPermission) {
        state = .loading

        Task {
            let result = await useCase.inviteUser(email: email, permission: permission)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load()
            }
        }
    }
}

// MARK: - ViewState

enum UserViewState: Equatable {
    case idle
    case loading
    case loaded
    case option
    case error(String)
}

// MARK: - Section

enum UserSection: Equatable {
    case inviteUsers([InviteUser])
    case users([User])

    var title: String {
        switch self {
        case .inviteUsers:
            return L10n.User.Invite.title
        case .users:
            return L10n.User.title
        }
    }

    var numberOfRows: Int {
        switch self {
        case .inviteUsers(let inviteUsers):
            return inviteUsers.count
        case .users(let users):
            return users.count
        }
    }
}
