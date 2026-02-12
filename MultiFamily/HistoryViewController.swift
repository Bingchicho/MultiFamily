//
//  EventHistoryViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

import UIKit

class HistoryViewController: UIViewController {
    

    @IBOutlet weak var tableView: UITableView!
    
    var device: Device?
    
    private let viewModel = HistoryViewModel(
        useCase: AppAssembler.makeHistoryUseCase()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bindViewModel()
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

            case .loaded:
                tableView.reloadData()

            default:
                break
            }
        }
        if let thingName = device?.thingName {
            viewModel.load(id: thingName)
        }
       
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
