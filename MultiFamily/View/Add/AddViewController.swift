//
//  AddViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import UIKit

class AddViewController: UIViewController {

    var provisionBLEInfo: ProvisionBLEInfo?
    var remotePinCode: String?
    
    @IBOutlet weak var idTitleLabel: AppLabel!
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var nameTitleLabel: AppLabel!
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var areaTitieLabel: AppLabel!
    @IBOutlet weak var areaButton: TintedButton!
    
    @IBOutlet weak var autoTitleLabel: AppLabel!
    @IBOutlet weak var autoSwitch: UISwitch!
    
    @IBOutlet weak var autoTimeTitieLabel: AppLabel!
    @IBOutlet weak var autoTimeButton: TintedButton!
    
    @IBOutlet weak var beepTitleLabel: AppLabel!
    @IBOutlet weak var beepSwitch: UISwitch!
    
    @IBOutlet weak var powerTitieLabel: AppLabel!
    @IBOutlet weak var powerButton: TintedButton!
    
    @IBOutlet weak var advTitieLabel: AppLabel!
    @IBOutlet weak var advButton: TintedButton!
    
    @IBOutlet weak var saveButton: UIButton!
    
    private lazy var viewModel =
    AddViewModel(
        provisionUseCase: AppAssembler.makeProvisionUseCase(),
        bleService: AppAssembler.makeBLEService()
    )
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
       bind()
    }
    
    private func bind() {
        
        if let provisionBLEInfo, let remotePinCode {
            viewModel.configure(provision: provisionBLEInfo, remotePinCode: remotePinCode)
            idTextField.text = provisionBLEInfo.uuid
        }
        
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            self.render(state)
        }

        viewModel.onRoute = { [weak self] route in
            guard let self else { return }
            switch route {
            case .close:
                self.performSegue(withIdentifier: "backhome", sender: nil)
            }
        }

        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        autoSwitch.addTarget(self, action: #selector(autoLockChanged), for: .valueChanged)
        beepSwitch.addTarget(self, action: #selector(beepChanged), for: .valueChanged)
    }
    
    
    
    
    
    @objc private func nameChanged() {
        viewModel.updateName(nameTextField.text ?? "")
    }

    @objc private func autoLockChanged() {
        viewModel.updateAutoLockOn(autoSwitch.isOn)
        autoTimeButton.isEnabled = autoSwitch.isOn
    }

    @objc private func beepChanged() {
        viewModel.updateBeepOn(beepSwitch.isOn)
    }
    
    private func render(_ state: AddDeviceViewState) {
        switch state {
        case .idle:
            holdLoading(animat: false)


        case .success:
            holdLoading(animat: false)
            showSuccess()

        case .error(let message):
            holdLoading(animat: false)
            showErrorAndDismiss(message)
        case .loading:
            holdLoading(animat: true)
        }
    }
    
    private func showSuccess() {
        let alert = UIAlertController(title: L10n.Registry.Success.title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        })
        present(alert, animated: true)
    }

    private func showErrorAndDismiss(_ message: String) {
        let alert = UIAlertController(title: L10n.Common.Error.title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default) { [weak self] _ in
           
        })
        present(alert, animated: true)
    }
    
    private func holdLoading(animat: Bool) {

        if animat {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }

        loadingIndicator.isHidden = !animat
        loadingBackground.isHidden = !animat

        // Only disable current screen interaction (avoid navigation freeze)
        view.isUserInteractionEnabled = !animat
    }
    private func setupUI() {
        idTitleLabel.style = .title
   
        nameTitleLabel.style = .title
        areaTitieLabel.style = .title
        autoTitleLabel.style = .title
        autoTimeTitieLabel.style = .title
        beepTitleLabel.style = .title
        powerTitieLabel.style = .title
        advTitieLabel.style = .title
     
        self.title = L10n.Registry.title
        saveButton.setTitle(L10n.Registry.Button.Save.title, for: .normal)
        idTitleLabel.text = L10n.Registry.Id.title
        nameTitleLabel.text = L10n.Registry.Name.title
        autoTitleLabel.text = L10n.Registry.AutoLock.title
        autoTimeTitieLabel.text = L10n.Registry.AutoLock.Time.title
        beepTitleLabel.text = L10n.Registry.Beep.title
        powerTitieLabel.text = L10n.Registry.Power.title
        advTitieLabel.text = L10n.Registry.Adv.title
    }
    
    @IBAction private func autoTimeButtonAction(sender: UIButton) {
        // 1...120 seconds
        let options = (1...120).map { "\($0)" }
        
        let current = viewModel.form.autoLockDelay ?? 1
        let selectedIndex = max(0, min(options.count - 1, current - 1))

        presentPicker(
            title: L10n.Registry.Picker.AutoLock.title,
            options: options,
            selectedIndex: selectedIndex,
            sourceView: sender
        ) { [weak self] selected in
            guard let self else { return }
            let value = Int(selected) ?? 1
            // Update VM + UI
            self.viewModel.updateAutoLockDelay(value)
            self.autoTimeButton.setTitle("\(value) S", for: .normal)
        }
    }

    @IBAction private func powerButtonAction(sender: UIButton) {
        // low / middle / high
        let options = [
            BLETxPower.low.title,
            BLETxPower.medium.title,
            BLETxPower.high.title
        ]

        let currentTitle = viewModel.form.txPower.title
        let selectedIndex = options.firstIndex(of: currentTitle) ?? 0

        presentPicker(
            title: L10n.Registry.Picker.Power.title,
            options: options,
            selectedIndex: selectedIndex,
            sourceView: sender
        ) { [weak self] selectedTitle in
            guard let self else { return }

            let value: BLETxPower
            switch selectedTitle {
            case BLETxPower.medium.title:
                value = .medium
            case BLETxPower.high.title:
                value = .high
            default:
                value = .low
            }

            self.viewModel.updateTxPower(value)
            self.powerButton.setTitle(value.title, for: .normal)
        }
    }

    @IBAction private func advButtonAction(sender: UIButton) {
        // low / high
        let options = [
            BLEAdv.low.title,
            BLEAdv.high.title
        ]

        let currentTitle = viewModel.form.adv.title
        let selectedIndex = options.firstIndex(of: currentTitle) ?? 0

        presentPicker(
            title: L10n.Registry.Picker.Adv.title,
            options: options,
            selectedIndex: selectedIndex,
            sourceView: sender
        ) { [weak self] selectedTitle in
            guard let self else { return }

            let value: BLEAdv = (selectedTitle == BLEAdv.high.title) ? .high : .low
            self.viewModel.updateAdv(value)
            self.advButton.setTitle(value.title, for: .normal)
        }
    }

    // MARK: - Picker Helper

    private func presentPicker(
        title: String,
        options: [String],
        selectedIndex: Int,
        sourceView: UIView,
        onPicked: @escaping (String) -> Void
    ) {
        let host = PickerHostViewController(
            titleText: title,
            options: options,
            selectedIndex: selectedIndex
        )

        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        alert.setValue(host, forKey: "contentViewController")

        let done = UIAlertAction(title: L10n.Common.Button.confirm, style: .default) { _ in
            onPicked(host.selectedValue)
        }
        let cancel = UIAlertAction(title: L10n.Common.Button.cancel, style: .cancel)

        alert.addAction(done)
        alert.addAction(cancel)

        // iPad safe
        if let pop = alert.popoverPresentationController {
            pop.sourceView = sourceView
            pop.sourceRect = sourceView.bounds
        }

        present(alert, animated: true)
    }

    private final class PickerHostViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

        private let titleText: String
        private let options: [String]
        private var selectedIndex: Int

        private let pickerView = UIPickerView()

        var selectedValue: String {
            guard options.indices.contains(selectedIndex) else { return options.first ?? "" }
            return options[selectedIndex]
        }

        init(titleText: String, options: [String], selectedIndex: Int) {
            self.titleText = titleText
            self.options = options
            self.selectedIndex = selectedIndex
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

        override func viewDidLoad() {
            super.viewDidLoad()

            view.backgroundColor = .clear

            pickerView.dataSource = self
            pickerView.delegate = self

            pickerView.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(pickerView)

            NSLayoutConstraint.activate([
                pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                pickerView.topAnchor.constraint(equalTo: view.topAnchor),
                pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                view.heightAnchor.constraint(equalToConstant: 216)
            ])

            let safeIndex = max(0, min(options.count - 1, selectedIndex))
            selectedIndex = safeIndex
            pickerView.selectRow(safeIndex, inComponent: 0, animated: false)
        }

        // MARK: UIPickerViewDataSource

        func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            options.count
        }

        // MARK: UIPickerViewDelegate

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            options[row]
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedIndex = row
        }
    }


}
