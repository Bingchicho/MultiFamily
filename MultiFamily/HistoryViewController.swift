//
//  EventHistoryViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

import UIKit
@MainActor
class HistoryViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var noDataContentLabel: AppLabel!
    @IBOutlet weak var noDataTitleLabel: AppLabel!
    @IBOutlet weak var noDataStackView: UIStackView!
    var device: Device?
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    private let viewModel = HistoryViewModel(
        useCase: AppAssembler.makeHistoryUseCase()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bindViewModel()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

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
        noDataTitleLabel.style = .title
        noDataContentLabel.style = .body
        
        noDataTitleLabel.text = L10n.History.Empty.title
        noDataContentLabel.text = L10n.History.Empty.content
    }
    
    private func setupTableView() {
        
        tableView.register(
            UINib(nibName: "HistoryTableViewCell", bundle: nil),
            forCellReuseIdentifier: "HistoryCell"
        )
        tableView.dataSource = self
        
    }
    
    private func bindViewModel() {

        viewModel.onStateChange = { [weak self] state in

            guard let self else { return }
        
            switch state {
            case .loading:
                holdLoading(animat: true)
            case .loaded(let history):
                holdLoading(animat: false)
                if history.count == 0 {
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

        if let thingName = device?.thingName {
            holdLoading(animat: true)
            viewModel.load(id: thingName)
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

extension HistoryViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.histories.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "HistoryCell",
            for: indexPath
        ) as! HistoryTableViewCell

        let history = viewModel.histories[indexPath.row]

        cell.configure(with: history)

        return cell
    }
}
