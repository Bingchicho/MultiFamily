//
//  ProvisionViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

import UIKit

class ProvisionViewController: UIViewController {

    @IBOutlet weak var contentLabel: AppLabel!
    @IBOutlet weak var actionLabel: AppLabel!
    
    private lazy var viewModel =
    ProvisionViewModel(
        provisionUseCase: AppAssembler.makeProvisionUseCase(),
        bleService: AppAssembler.makeBLEService()
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        bindViewModel()
        
        if let id = AppAssembler.siteSelectionStore.currentSite?.id {
            viewModel.configure(siteID: id, model: "MFA_THING")
        }
        render(.idle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.start()
    }
    
    private func setupUI() {
        contentLabel.style = .body
        actionLabel.style = .title
        
        contentLabel.text = L10n.Add.Content.title
    }
    
    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            self?.render(state)
        }

        viewModel.onRoute = { [weak self] route in
            self?.handle(route)
        }
    }

    private func render(_ state: ProvisionViewState) {
        switch state {
        case .idle:
      
            actionLabel.text = "Provisioning..."

        case .loading(let message):
       
            actionLabel.text = message

        case .success:
           break
       

        case .error(let message):
        
            showError(message)
        }
    }

    private func handle(_ route: ProvisionRoute) {
        switch route {
        case .next(let bt):
            // 1) If you are using segue, keep data then performSegue
            // 2) Or push directly
            performSegue(withIdentifier: "toRegistry", sender: (bt))
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toRegistry",
           let (bt) = sender as? (ProvisionBLEInfo),
            let vc = segue.destination as? AddViewController {
            vc.provisionBLEInfo = bt
            vc.viewModel = viewModel
          
        }
    }

    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: L10n.Common.Error.title,
            message: message,
            preferredStyle: .alert
        )

        let confirm = UIAlertAction(
            title: L10n.Common.Button.confirm,
            style: .default
        ) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }

        alert.addAction(confirm)
        present(alert, animated: true)
    }


}
