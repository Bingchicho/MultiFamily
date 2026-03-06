//
//  UserListUseCase.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/6.
//



import Foundation

protocol UserUseCase {
    func execute() async -> UserListResult

    func update(siteId: String, userId: String, role: UserRole) async -> UserListResult
    func delete(siteId: String, userId: String) async -> UserListResult

    func inviteResend(code: String) async -> UserListResult
    func inviteDelete(code: String) async -> UserListResult

    func inviteUser(email: String, permission: UserPermission) async -> UserListResult
}


struct UserUseCaseImpl: UserUseCase {

    private let repository: UserRepository

    init(repository: UserRepository) {
        self.repository = repository
    }

    func execute() async -> UserListResult {
        
        let result: UserListResult

        do {
            result = try await repository.list()
        } catch {
            return .failure(error.localizedDescription)
        }
        
        switch result {
        case .success(let users, let inviteUsers):
            let selectedSiteId = AppAssembler.siteSelectionStore.currentSite?.id ?? ""

            let filteredUsers = users
                .filter { user in
                    matchesSelectedSite(group: user.group, selectedSiteId: selectedSiteId)
                }
                .sorted { lhs, rhs in
                    lhs.name.localizedCaseInsensitiveCompare(rhs.name) == .orderedAscending
                }

            let filteredInviteUsers = inviteUsers
                .filter { inviteUser in
                    inviteUser.siteID == selectedSiteId
                }
                .sorted { lhs, rhs in
                    lhs.email.localizedCaseInsensitiveCompare(rhs.email) == .orderedAscending
                }

            return .success(users: filteredUsers, inviteUsers: filteredInviteUsers)
        case .failure:
            return .failure(L10n.Common.Error.network)
      
        case .optionSuccess:
            return .optionSuccess
        }
        
    
    }
    

    private func matchesSelectedSite(group: String?, selectedSiteId: String) -> Bool {
        guard selectedSiteId.isEmpty == false else { return false }
        guard let group else { return false }

        let normalizedGroup = group
            .replacingOccurrences(of: "\\/", with: "/")
            .trimmingCharacters(in: .whitespacesAndNewlines)

        // Global wildcard permission: SunionMFA/*
        if normalizedGroup.hasSuffix("/*") {
            return false
        }

        // Precise match by path segment to avoid false positives.
        let segments = normalizedGroup
            .split(separator: "/")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }

        return segments.contains(selectedSiteId)
    }
    
    func update(siteId: String, userId: String, role: UserRole) async -> UserListResult {
        do {
            try await repository.update(siteId: siteId, userId: userId, role: role)
            return .optionSuccess
        } catch {
            return .failure(error.localizedDescription)
        }
    }

    func delete(siteId: String, userId: String) async -> UserListResult {
        do {
            try await repository.delete(siteId: siteId, userId: userId)
            return .optionSuccess
        } catch {
            return .failure(error.localizedDescription)
        }
    }

    func inviteResend(code: String) async -> UserListResult {
        do {
            try await repository.inviteResend(code: code)
            return .optionSuccess
        } catch {
            return .failure(error.localizedDescription)
        }
    }

    func inviteDelete(code: String) async -> UserListResult {
        do {
            try await repository.inviteDelete(code: code)
            return .optionSuccess
        } catch {
            return .failure(error.localizedDescription)
        }
    }

    func inviteUser(email: String, permission: UserPermission) async -> UserListResult {
        do {
            try await repository.inviteUser(email: email, permission: permission)
            return .optionSuccess
        } catch {
            return .failure(error.localizedDescription)
        }
    }
}
