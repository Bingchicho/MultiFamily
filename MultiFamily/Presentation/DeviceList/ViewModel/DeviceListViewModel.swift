//
//  DeviceListViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

@MainActor
final class DeviceListViewModel {

    private let useCase: DeviceUseCase

    private(set) var state: DeviceListViewState = .idle {
        didSet { onStateChange?(state) }
    }

    private(set) var devices: [Device] = []

    var onStateChange: ((DeviceListViewState) -> Void)?

    init(useCase: DeviceUseCase) {
        self.useCase = useCase
    }

    func load(siteID: String) {

        state = .loading

        Task {

            let result = await useCase.execute(siteID: siteID)

            switch result {

            case .success(let devices):

                self.devices = devices
                self.state = .loaded(devices)

            case .failure(let message):

                self.state = .error(message)
            }
        }
    }

    func device(at index: Int) -> Device {

        devices[index]
    }

    var count: Int {

        devices.count
    }
}
