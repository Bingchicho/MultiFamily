//
//  RegistryViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

import UIKit

class RegistryViewController: UIViewController {
    
    @IBOutlet weak var idTitleLabel: AppLabel!
    @IBOutlet weak var idLabel: AppLabel!
    
    @IBOutlet weak var nameTitleLabel: AppLabel!
    @IBOutlet weak var nameTextField: UITextField!
    
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
    
    @IBOutlet weak var saveButton: TextButton!
    
    var data: DetailResponseDTO?
    
    private lazy var viewModel =
    RegistryViewModel(
        useCase: AppAssembler.makeRegistryUseCase()
    )
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
      
    }
    
    private func bind() {
        
        if let data = data {
            viewModel.configure(with: data)
            setupData(data: data)
        }
        
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            self.render(state)
        }

        viewModel.onRoute = { [weak self] route in
            guard let self else { return }
            switch route {
            case .dismiss:
                self.dismiss(animated: true)
            }
        }

        nameTextField.addTarget(self, action: #selector(nameChanged), for: .editingChanged)
        autoSwitch.addTarget(self, action: #selector(autoLockChanged), for: .valueChanged)
        beepSwitch.addTarget(self, action: #selector(beepChanged), for: .valueChanged)
    }
    
    private func setupData(data: DetailResponseDTO) {
  
        idLabel.text = String(data.deviceID)
        nameTextField.text = viewModel.form.name
        autoSwitch.isOn = viewModel.form.isAutoLockOn
        if let time = viewModel.form.autoLockDelay {
            autoTimeButton.setTitle("\(time) S", for: .normal)
        }
      
        beepSwitch.isOn = viewModel.form.isBeepOn
        powerButton.setTitle(viewModel.form.txPower.title, for: .normal)
        advButton.setTitle(viewModel.form.adv.title, for: .normal)
        
        
        
    }
    
    @objc private func nameChanged() {
        viewModel.setName(nameTextField.text ?? "")
    }

    @objc private func autoLockChanged() {
        viewModel.setAutoLockOn(autoSwitch.isOn)
        autoTimeButton.isEnabled = autoSwitch.isOn
    }

    @objc private func beepChanged() {
        viewModel.setBeepOn(beepSwitch.isOn)
    }

    @IBAction private func tapSave() {
        if let thingName = data?.thingName {
            viewModel.tapSave(thingName: thingName)
        }
    }

    @IBAction private func tapCancel() {
        viewModel.tapCancel()
    }
    
    private func render(_ state: RegistryViewState) {
        switch state {
        case .idle:
            holdLoading(animat: false)

        case .editing(let isSaveEnabled):
            holdLoading(animat: false)
            saveButton.isEnabled = isSaveEnabled

        case .saving:
            holdLoading(animat: true)
            saveButton.isEnabled = false

        case .success:
            holdLoading(animat: false)
            showSuccess()

        case .error(let message):
            holdLoading(animat: false)
            showErrorAndDismiss(message)
        }
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
    
    private func showSuccess() {
        let msg = "設定成功（需同步）"
        let alert = UIAlertController(title: "Success", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }

    private func showErrorAndDismiss(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.dismiss(animated: true)
        })
        present(alert, animated: true)
    }
    private func setupUI() {
        idTitleLabel.style = .body
        idLabel.style = .body
        nameTitleLabel.style = .title
        autoTitleLabel.style = .title
        autoTimeTitieLabel.style = .title
        beepTitleLabel.style = .title
        powerTitieLabel.style = .title
        advTitieLabel.style = .title
        
    }
}
