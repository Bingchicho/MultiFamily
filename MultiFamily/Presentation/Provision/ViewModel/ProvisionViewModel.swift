//
//  ProvisionViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//
import Foundation

@MainActor
final class ProvisionViewModel {

    private(set) var state: ProvisionViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((ProvisionViewState) -> Void)?
    var onRoute: ((ProvisionRoute) -> Void)?

    private let provisionUseCase: ProvisionUseCase


    // 外部從上一頁帶進來（你說 form 不要 init 就要求資料：這裡用 configure 方式）
    private var siteID: String?
    private var model: String?
    private var activeMode: ActiveModeDTO = .ble
    


    private(set) var form: AddForm = .init()
    
    
    
    var isValid: Bool {
        // Name + Area 必填
        guard !form.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }

        return true
    }

     private var provision: ProvisionBLEInfo?
  

    init(provisionUseCase: ProvisionUseCase) {
        self.provisionUseCase = provisionUseCase
        
    }

    func configure(siteID: String, model: String, activeMode: ActiveModeDTO = .ble) {
        self.siteID = siteID
        self.model = model
        self.activeMode = activeMode
    }

    func start() {
        guard let siteID, let model else {
            state = .error(L10n.Common.Error.network)
            return
        }

        Task { [activeMode] in
            do {
                state = .loading(L10n.Add.Status.provision)

                let provision = try await provisionUseCase.provision(
                    siteID: siteID,
                    activeMode: activeMode,
                    model: model
                )

                state = .loading(L10n.Add.Status.connecting)

                let info = ProvisionBLEInfo(
                    uuid: provision.bt.uuid,
                    key: provision.bt.key,
                    token: provision.bt.token,
                    iv: provision.bt.iv,
                    remotePinCode: provision.remotePinCode
                )

                state = .success
                onRoute?(.next(bt: info))

            } catch {
                state = .error(L10n.Common.Error.network)
            }
        }
    }
    
    
  
}
