//
//  AddViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/11.
//


import Foundation

@MainActor
final class AddViewModel {

    private(set) var state: AddDeviceViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((AddDeviceViewState) -> Void)?

    private let AddUseCase: AddUseCase

    
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

     private var Add: ProvisionBLEInfo?
  

    init(AddUseCase: AddUseCase) {
        self.AddUseCase = AddUseCase
        
    }

    
    // add
    
    func addConfigure(Add: ProvisionBLEInfo) {

        self.form = AddForm(lockID: Add.uuid, name: "", area: .public, isAutoLockOn: false, autoLockDelay: 5, isBeepOn: true, txPower: .medium, adv: .low, group: nil)
        self.Add = Add
        
    
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
            guard let Add else {
                state = .error(L10n.Common.Error.network)
                return
            }

            addState = .loading

            Task {
                do {
            
                   _ = try await AddUseCase.submit(
                        siteID: siteID,
                        name: form.name,
                        activeMode: "ble",
                        model: "MFA_THING",
                        isResident: form.area?.boolValue ?? false,
                        deviceID: Int(form.lockID) ?? 0,
                        Add: Add,
                        form: form,
                
                    )

                    addState = .success
          

                } catch {
                    addState = .error(L10n.Common.Error.network)
                }
            }
        }
}
