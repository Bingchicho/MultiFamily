//
//  ProvisionViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//


@MainActor
final class ProvisionViewModel {

    private(set) var state: ProvisionViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ProvisionViewState) -> Void)?
    var onRoute: ((ProvisionRoute) -> Void)?

    private let provisionUseCase: ProvisionUseCase
    private let bleService: BLEService


    // 外部從上一頁帶進來（你說 form 不要 init 就要求資料：這裡用 configure 方式）
    private var siteID: String?
    private var model: String?
    private var activeMode: ActiveModeDTO = .ble

    init(provisionUseCase: ProvisionUseCase,
         bleService: BLEService) {
        self.provisionUseCase = provisionUseCase
        self.bleService = bleService
    }

    func configure(siteID: String, model: String, activeMode: ActiveModeDTO = .ble) {
        self.siteID = siteID
        self.model = model
        self.activeMode = activeMode
    }

    func start() {
        guard let siteID, let model else {
            state = .error("Missing siteID/model")
            return
        }

        Task { [activeMode] in
            do {
                state = .loading("Provisioning...")

                let provision = try await provisionUseCase.provision(
                    siteID: siteID,
                    activeMode: activeMode,
                    model: model
                )

                state = .loading("Connecting BLE...")

                let info = ProvisionBLEInfo(
                    uuid: provision.bt.uuid,
                    key: provision.bt.key,
                    token: provision.bt.token,
                    iv: provision.bt.iv
                )

        
                try await bleService.connection()

                state = .success
                onRoute?(.next(bt: info, remotePinCode: provision.remotePinCode))

            } catch {
                state = .error(L10n.Common.Error.network)
            }
        }
    }
}
