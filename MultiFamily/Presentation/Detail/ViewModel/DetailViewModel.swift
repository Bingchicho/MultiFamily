//
//  DetailViewModel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

@MainActor
final class DetailViewModel {

    private(set) var state: DetailViewState = .idle {
        didSet { onStateChange?(state) }
    }

    var onStateChange: ((DetailViewState) -> Void)?

    private let useCase: DetailUseCase
    
    private(set) var detail: Detail?
    
    // MARK: - UI Output

       var batteryText: String {
           guard let detail else { return "-" }
           return "\(detail.battery)%"
       }

       var autoLockText: String {
           guard let detail else { return "-" }
           return detail.autoLock
           ? "\(detail.autoLockDelay)S"
           : L10n.Detail.Off.title
       }

       var beepText: String {
           guard let detail else { return "-" }
           return detail.beep
           ? L10n.Detail.On.title
           : L10n.Detail.Off.title
       }

       var updateTimeText: String {
           guard let detail else { return "-" }
           return detail.updateAt
       }

       var blePowerText: String {
           guard let detail else { return "-" }
           return detail.bleTxPower.bleLevelText
       }

       var bleAdvText: String {
           guard let detail else { return "-" }
           return detail.bleAdv.bleLevelText
       }


    init(useCase: DetailUseCase) {
        self.useCase = useCase
    }

    func load(thingName: String) {

        state = .loading

        Task {

            let result =
                await useCase.execute(
                    thingName: thingName
                )

            switch result {

            case .success(let detail):
                self.detail = detail
        
                self.state = .loaded(response: useCase.response)

            case .failure:
                state = .error(L10n.Common.Error.network)

            }

        }

    }
    
    func remove(thingName: String) {

        state = .loading

        Task {

            let result =
            await useCase.remove(
                    thingName: thingName
                )

            switch result {

            case .success:
                
                state = .deleted

            case .failure:
                state = .error(L10n.Common.Error.network)

            }

        }

    }

}

extension Int {

    var bleLevelText: String {
        switch self {
        case 1...30:
            return L10n.Detail.Low.title
        case 31...60:
            return L10n.Detail.Middle.title
        case 61...100:
            return L10n.Detail.Hight.title
        default:
            return "-"
        }
    }

}
