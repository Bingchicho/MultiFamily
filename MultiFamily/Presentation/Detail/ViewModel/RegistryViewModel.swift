//
//  RegistryViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

@MainActor
final class RegistryViewModel {

    // MARK: - Output
    private(set) var state: RegistryViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((RegistryViewState) -> Void)?
    var onRoute: ((RegistryRoute) -> Void)?

    // MARK: - Dependencies

    private let useCase: RegistryUseCase

    // MARK: - Form (Input)
    private var originalForm: RegistryForm?
    private(set) var form: RegistryForm = .init() {
        didSet { validateAndEmit() }
    }

    init(useCase: RegistryUseCase) {
        self.useCase = useCase
    }

    func configure(with data: DetailResponseDTO) {
        
        let form = RegistryForm(
            name: data.name ?? "",
            isAutoLockOn: data.attributes?.autoLock == "Y",
            autoLockDelay: data.attributes?.autoLockDelay,
            isBeepOn: data.attributes?.operatorVoice == "Y",
            txPower: BLETxPower(rawValue: data.attributes?.bleTXPower ?? 30) ?? .low,
            adv: BLEAdv(rawValue: data.attributes?.bleAdv ?? 30) ?? .low
        )

        originalForm = form
        self.form = form
    }

    // MARK: - Update input (VC 透過這些方法改值)
    func setName(_ name: String) {
        form.name = name
    }

    func setAutoLockOn(_ on: Bool) {
        form.isAutoLockOn = on
        if !on { form.autoLockDelay = nil } // 關閉就清掉
    }

    func setAutoLockDelay(_ value: Int) {
        form.autoLockDelay = value
    }

    func setBeepOn(_ on: Bool) {
        form.isBeepOn = on
    }

    func setTxPower(_ value: BLETxPower) {
        form.txPower = value
    }

    func setAdv(_ value: BLEAdv) {
        form.adv = value
    }

    // MARK: - Actions
    func tapCancel() {
        onRoute?(.dismiss)
    }

    func tapSave(thingName: String) {
        guard isValid else { return }
        if case .saving = state { return }

        state = .saving

        Task {
            let result = await useCase.execute(
                thingName: thingName,
                form: form
            )

            switch result {
            case .success:
                state = .success
            case .failure:
                state = .error(message: L10n.Common.Error.network)
            }
        }
    }

    // MARK: - Validation
    private var isValid: Bool {
        guard let originalForm else { return false }

        // Only enable save if form changed
        return form != originalForm
    }

    private func validateAndEmit() {
        // idle/editing 都可以統一轉成 editing 讓 VC 更新 save 按鈕狀態
        if case .saving = state { return } // saving 時不覆蓋 state
        state = .editing(isSaveEnabled: isValid)
    }
}
