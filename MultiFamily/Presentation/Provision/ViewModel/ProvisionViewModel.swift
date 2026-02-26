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
    private let bleService: BLEService


    // 外部從上一頁帶進來（你說 form 不要 init 就要求資料：這裡用 configure 方式）
    private var siteID: String?
    private var model: String?
    private var activeMode: ActiveModeDTO = .ble
    
    
    // add頁面從這邊 因應bleService要同一個
    
    private(set) var addState: AddDeviceViewState = .idle {
        didSet { addonStateChange?(addState) }
    }

    var addonStateChange: ((AddDeviceViewState) -> Void)?
 


    private(set) var form: AddForm = .init()
    
    
    
    var isValid: Bool {
        // Name + Area 必填
        guard !form.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }

        return true
    }

     private var provision: ProvisionBLEInfo?
  

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

        
                try await bleService.connection()

                state = .success
                onRoute?(.next(bt: info))

            } catch {
                state = .error(L10n.Common.Error.network)
            }
        }
    }
    
    
    // add
    
    func addConfigure(provision: ProvisionBLEInfo) {

        self.form = AddForm(lockID: provision.uuid, name: "", area: .public, isAutoLockOn: false, autoLockDelay: 5, isBeepOn: true, txPower: .medium, adv: .low, group: nil)
        self.provision = provision
        
    
    }
    
    // MARK: - Input mutations
       func updateName(_ value: String) {
           form.name = value
         
       }

       func updateArea(_ value: LockArea) {
           form.area = value
     
       }

       func updateAutoLockOn(_ isOn: Bool) {
           form.isAutoLockOn = isOn
           if !isOn { form.autoLockDelay = nil } // 關掉就清空
           
       }

       func updateAutoLockDelay(_ value: Int) {
           form.autoLockDelay = value
      
       }

       func updateBeepOn(_ isOn: Bool) {
           form.isBeepOn = isOn
          
       }

       func updateTxPower(_ value: BLETxPower) {
           form.txPower = value
          
       }

       func updateAdv(_ value: BLEAdv) {
           form.adv = value
         
       }
    

    


    // MARK: - Actions
    func save(siteID: String) {
            guard let provision else {
                state = .error(L10n.Common.Error.network)
                return
            }

            addState = .loading

            Task {
                do {
                    // 1) BLE side: write settings / fetch registry
                    try await bleService.provisionAndFetchRegistry(
                        btInfo: provision,
                        addform: form,
                        siteID: siteID
                    )

                    // 2) Server side: submit device/add
                   _ = try await provisionUseCase.submit(
                        siteID: siteID,
                        name: form.name,
                        activeMode: "ble",
                        model: "MFA_THING",
                        isResident: form.area?.boolValue ?? false,
                        deviceID: Int(form.lockID) ?? 0,
                        remotePinCode: provision.remotePinCode,
                        bt: DeviceAddBTRequestDTO(
                            uuid: provision.uuid,
                            key: provision.key,
                            token: provision.token,
                            iv: provision.iv
                        ),
                        attributes: DeviceAddAttributesDTO(
                            autoLock: form.isAutoLockOn ? "Y" : "N",
                            autoLockDelay: form.autoLockDelay,
                            operatorVoice: form.isBeepOn ? "Y" : "N",
                            bleTXPower: form.txPower.rawValue,
                            bleAdv: form.adv.rawValue
                        )
                    )

                    addState = .success
          

                } catch {
                    addState = .error(L10n.Common.Error.network)
                }
            }
        }
}
