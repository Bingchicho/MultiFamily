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
    
    private var sideID: String?

    init(useCase: UserUseCase) {
        self.useCase = useCase
    }

    func load(siteId: String) {
        state = .loading
        sideID = siteId
        Task {
            let result = await useCase.execute(siteId: siteId)

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

    func update( userId: String, role: UserRole) {
        guard let siteID = sideID else { return }
        state = .loading

        Task {
            let result = await useCase.update(siteId: siteID, userId: userId, role: role)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load(siteId: siteID)
            }
        }
    }

    func delete( userId: String) {
        guard let siteID = sideID else { return }
        state = .loading

        Task {
            let result = await useCase.delete(siteId: siteID, userId: userId)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load(siteId: siteID)
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
                state = .option
            }
        }
    }

    func inviteDelete(code: String) {
        guard let siteID = sideID else { return }
        state = .loading

        Task {
            let result = await useCase.inviteDelete(code: code)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load(siteId: siteID)
            }
        }
    }

    func inviteUser(email: String, permission: UserPermission) {
        guard let siteID = sideID else { return }
        state = .loading

        Task {
            let result = await useCase.inviteUser(email: email, permission: permission)

            switch result {
            case .success:
                break
            case .failure(let message):
                state = .error(message)
            case .optionSuccess:
                load(siteId: siteID)
            }
        }
    }
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
