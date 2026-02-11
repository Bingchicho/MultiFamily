import Foundation
@MainActor

final class DeviceListViewModel {

    // MARK: - Dependency

    private let useCase: DeviceUseCase

    // MARK: - State

    private(set) var state: DeviceListViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((DeviceListViewState) -> Void)?

    // MARK: - Source Data

    private(set) var devices: [Device] = []

    // MARK: - Search State

    private var filteredDevices: [Device] = []
    private(set) var isSearching: Bool = false

    // MARK: - Init

    init(useCase: DeviceUseCase) {
        self.useCase = useCase
    }

    // MARK: - Load

    func load(siteID: String) {

        state = .loading

        Task {

            let result = await useCase.execute(siteID: siteID)

            switch result {

            case .success(let devices):

                // Sort by name for stable UI
                self.devices = devices.sorted {
                    $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
                }

                self.filteredDevices = self.devices
                self.isSearching = false

                state = .loaded(self.devices)

            case .failure(let message):

                state = .error(message)
            }
        }
    }

    // MARK: - Search

    func search(keyword: String) {

        let trimmed = keyword.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !trimmed.isEmpty else {
            isSearching = false
            filteredDevices = devices
            return
        }

        isSearching = true

        filteredDevices = devices.filter {
            $0.name.localizedCaseInsensitiveContains(trimmed)
        }
    }

    // MARK: - Display Helpers

    var displayCount: Int {
        isSearching ? filteredDevices.count : devices.count
    }

    func displayDevice(at index: Int) -> Device {
        isSearching
        ? filteredDevices[index]
        : devices[index]
    }
}
