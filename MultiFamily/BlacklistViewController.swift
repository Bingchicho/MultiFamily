//
//  BlacklistViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//


import UIKit
@MainActor
class BlacklistViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataContentLabel: AppLabel!
    @IBOutlet weak var noDataTitleLabel: AppLabel!
    @IBOutlet weak var noDataStackView: UIStackView!
 
    private lazy var viewModel =
        PermissionViewModel(
            useCase: AppAssembler.makePermissionUseCase()
        )
    var device: Device?
    
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        setupTableView()
        setupUI()
    }
    
    private func setupUI() {
        noDataTitleLabel.style = .title
        noDataContentLabel.style = .body
        
        noDataTitleLabel.text = L10n.Black.Empty.title
        noDataContentLabel.text = L10n.Black.Empty.content
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
    
    private func setupTableView() {
        
  
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "SystemCell")
    }

    private func bind() {

        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            self.render(state)
        }
        
        if let thingName = device?.thingName {
            holdLoading(animat: true)
            viewModel.load(thingName: thingName)
        }
    }

    private func render(
        _ state: PermissionViewState
    ) {

        switch state {

        case .loading:

            holdLoading(animat: true)

        case .loaded( _ , let card):
            holdLoading(animat: false)
            if card.isEmpty {
                noDataStackView.isHidden = false
            } else {
                noDataStackView.isHidden = true
                tableView.reloadData()
            }
         
         

        case .error(let message):

            holdLoading(animat: false)
            showError(message)
        default:
            holdLoading(animat: false)
        }
    }
    
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: L10n.Common.Error.title,
            message: message,
            preferredStyle: .alert
        )
    
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }

}


extension BlacklistViewController: UITableViewDataSource {
    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.users.count
    }
    
    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "SystemCell", for: indexPath)

        let user = viewModel.users[indexPath.row]

        cell.textLabel?.text = user.name



        return cell
    }
}
