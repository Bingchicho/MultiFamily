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
        case updated
    }

    // MARK: - Output

    var onStateChange: ((State) -> Void)?

    // MARK: - Data

    private(set) var publicLocks: [Device] = []
    private(set) var privateLocks: [Device] = []

    private(set) var selectedPublicLocks: Set<String> = []
    private(set) var selectedPrivateLocks: Set<String> = []

    private(set) var email: String = ""

    var isValid: Bool {
        email.isEmpty == false && (!selectedPublicLocks.isEmpty || !selectedPrivateLocks.isEmpty)
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
}
