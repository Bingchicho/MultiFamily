//
//  AddViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/25.
//

import Foundation

@MainActor
final class AddViewModel {

    private(set) var state: AddDeviceViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((AddDeviceViewState) -> Void)?
    var onRoute: ((AddDeviceRoute) -> Void)?

    private let provisionUseCase: ProvisionUseCase
    private let bleService: BLEService


    private(set) var form: AddForm = .init()
    
    
    
    var isValid: Bool {
        // Name + Area 必填
        guard !form.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return false }

        return true
    }

     private var provision: ProvisionBLEInfo?
     private var remotePinCode: String?

    init(provisionUseCase: ProvisionUseCase,
         bleService: BLEService) {
        self.provisionUseCase = provisionUseCase
        self.bleService = bleService
    }

    func configure(provision: ProvisionBLEInfo,
                   remotePinCode: String) {

        self.form = AddForm(lockID: provision.uuid, name: "", area: .public, isAutoLockOn: false, autoLockDelay: 5, isBeepOn: true, txPower: .medium, adv: .low, group: nil)
        self.provision = provision
        self.remotePinCode = remotePinCode
        
    
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
        func save() {
            guard let provision, let remotePinCode else {
                state = .error("Missing provision info")
                return
            }

            state = .loading

            Task {
                do {
//                    let needsSyncHint = try await useCase.submit(
//                        form: form,
//                        provision: provision,
//                        remotePinCode: remotePinCode
//                    )
//
//                    state = .success(needsSyncHint: needsSyncHint)
//                    onRoute?(.close)

                } catch {
                    state = .error(L10n.Common.Error.network)
                }
            }
        }
}
