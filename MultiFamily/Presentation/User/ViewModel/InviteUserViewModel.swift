//
//  InviteUserViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/9.
//


// MARK: - ViewModel
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

    // MARK: - Data

    private(set) var publicLocks: [Device] = []
    private(set) var privateLocks: [Device] = []

    private(set) var selectedPublicLocks: Set<String> = []
    private(set) var selectedPrivateLocks: Set<String> = []

    private(set) var email: String = ""
    
    private let useCase: UserUseCase

    var isValid: Bool {
        email.isEmpty == false && (!selectedPublicLocks.isEmpty || !selectedPrivateLocks.isEmpty)
    }
    
    init(useCase: UserUseCase) {
        self.useCase = useCase
    }

    // MARK: - Setup

    func configure(devices: [Device]) {

        publicLocks = devices.filter { $0.isResident == false }
        privateLocks = devices.filter { $0.isResident == true }

        onStateChange?(.updated)
    }

    // MARK: - Actions

    func updateEmail(_ value: String) {
        email = value
        onStateChange?(.updated)
    }

    func togglePublicLock(_ device: Device) {

        if selectedPublicLocks.contains(device.thingName) {
            selectedPublicLocks.remove(device.thingName)
        } else {
            selectedPublicLocks.insert(device.thingName)
        }

        onStateChange?(.updated)
    }

    func togglePrivateLock(_ device: Device) {

        if selectedPrivateLocks.contains(device.thingName) {
            selectedPrivateLocks.remove(device.thingName)
        } else {
            selectedPrivateLocks.insert(device.thingName)
        }

        onStateChange?(.updated)
    }
    
    func inviteUser(siteId: String,email: String, userRole: String,publicDevice: [String], privateDevice: [String]) {
        onStateChange?(.loading)
      
        Task {
            var permissions: [InviteuserPermissionDevices] = []
            publicDevice.forEach { thingname in
                permissions.append(.init(thingName: thingname, deviceRole: .sync))
            }
            privateDevice.forEach { thingname in
                permissions.append(.init(thingName: thingname, deviceRole: .sync))
            }
            let payload: InviteuserPermission = .init(siteID: siteId, userRole: userRole, devices: permissions)
            let result = await useCase.inviteUser(email: email, permission: payload)

            switch result {

            case .success:
         
              
                onStateChange?(.created)

            case .failure(let message):
               
                onStateChange?(.error(message))
           
            case .optionSuccess:
                break
            }
        }
    }
}
