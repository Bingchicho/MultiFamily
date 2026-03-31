//
//  InviteUserViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/9.
//

import Foundation

@MainActor

final class InviteUserViewModel {

    enum State {
        case idle
        case loading
        case updated
        case created
        case error(String)
    }

    // MARK: - Output

    var onStateChange: ((State) -> Void)?
    private(set) var state: State = .idle {
        didSet { onStateChange?(state) }
    }

    // MARK: - Data

    private(set) var publicLocks: [Device] = []
    private(set) var privateLocks: [Device] = []

    private(set) var selectedPublicLocks: Set<String> = []
    private(set) var selectedPrivateLocks: Set<String> = []

    private(set) var email: String = ""
    private(set) var selectedRole: String = "User"
    
    private let useCase: UserUseCase

    var isValid: Bool {
        email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false
        && (!selectedPublicLocks.isEmpty || !selectedPrivateLocks.isEmpty)
    }
    
    init(useCase: UserUseCase) {
        self.useCase = useCase
    }

    // MARK: - Setup

    func configure(devices: [Device]) {

        publicLocks = devices.filter { $0.isResident == false }
        privateLocks = devices.filter { $0.isResident == true }

        state = .updated
    }

    // MARK: - Actions

    func updateEmail(_ value: String) {
        email = value.trimmingCharacters(in: .whitespacesAndNewlines)
        state = .updated
    }
    
    func updateRole(_ role: String) {
        selectedRole = role
        state = .updated
    }

    func togglePublicLock(_ device: Device) {

        if selectedPublicLocks.contains(device.thingName) {
            selectedPublicLocks.remove(device.thingName)
        } else {
            selectedPublicLocks.insert(device.thingName)
        }

        state = .updated
    }

    func togglePrivateLock(_ device: Device) {

        if selectedPrivateLocks.contains(device.thingName) {
            selectedPrivateLocks.remove(device.thingName)
        } else {
            selectedPrivateLocks.insert(device.thingName)
        }

        state = .updated
    }
    
    func inviteUser(siteId: String) {
        guard isValid else {
            state = .error("Invalid invite data")
            return
        }

        state = .loading

        Task {
            var permissions: [InviteuserPermissionDevices] = []

            selectedPublicLocks.forEach { thingName in
                permissions.append(.init(thingName: thingName, deviceRole: .sync))
            }

            selectedPrivateLocks.forEach { thingName in
                permissions.append(.init(thingName: thingName, deviceRole: .residential))
            }

            let payload = InviteuserPermission(
                siteID: siteId,
                userRole: selectedRole,
                devices: permissions
            )

            let result = await useCase.inviteUser(email: email, permission: payload)
            
            switch result {
            case .success:
                
                break
            case .failure(let message):
                state = .error(message)
                
            case .optionSuccess:
                state = .created
            }
        }
    }
}
