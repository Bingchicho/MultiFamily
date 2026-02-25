//
//  HomeViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

import UIKit
@MainActor
class HomeViewController: UIViewController {
    
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var noDataStackView: UIStackView!
    @IBOutlet weak var noDataTitleLabel: AppLabel!
    @IBOutlet weak var noDataAddButton: PrimaryButton!
    
    @IBOutlet weak var noDataContentLabel: AppLabel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    private lazy var viewModel =
        DeviceListViewModel(
            useCase: AppAssembler.makeDeviceUseCase()
        )
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        searchBar.delegate = self
        setupUI()
        bind()
        
        if let id = AppAssembler.siteSelectionStore.currentSite?.id {
            viewModel.load(siteID: id)
        } else {
            self.performSegue(withIdentifier: "site", sender: nil)
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
    
    private func setupTableView() {
        
        tableView.register(
            UINib(nibName: "DeviceTableViewCell", bundle: nil),
            forCellReuseIdentifier: "DeviceCell"
        )

        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func bind() {

          viewModel.onStateChange = { [weak self] state in

              guard let self else { return }

              switch state {

              case .loading:
                  holdLoading(animat: true)

              case .loaded:
                  holdLoading(animat: false)
                  noDataStackView.isHidden = !viewModel.devices.isEmpty
                  tableView.isHidden = viewModel.devices.isEmpty
                  addButton.isHidden = viewModel.devices.isEmpty
                  if !viewModel.devices.isEmpty {
                      tableView.reloadData()
                  }

                  tableView.reloadData()

              case .error(let message):
                  holdLoading(animat: false)

              default:
                  break
              }
          }
      }
    
    private func setupUI() {
        self.title = L10n.Home.title
        siteButton.setTitle("", for: .normal)
        accountButton.setTitle("", for: .normal)
        addButton.setTitle("", for: .normal)
        
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
        
        noDataTitleLabel.style = .title
        noDataContentLabel.style = .body
        
        noDataTitleLabel.text = L10n.Home.Empty.title
        noDataContentLabel.text = L10n.Home.Empty.content
        noDataAddButton.setTitle(L10n.Home.Button.addLock, for: .normal)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "site",
           let vc = segue.destination as? SiteListViewController {
            vc.delegate = self
        }
        
        if segue.identifier == "detail",
           let vc = segue.destination as? DetailViewController {
            vc.device = sender as? Device
        }
    }
    
    
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        if let id = AppAssembler.siteSelectionStore.currentSite?.id {
            viewModel.load(siteID: id)
        }
    }
}


extension HomeViewController: SiteListDelegate {
    func siteListDidSelect(_ site: Site) {
        AppLogger.log(.info, category: .site, "selected site: \(site)")
    
        viewModel.load(siteID: site.id)
    }
    
    
}


extension HomeViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        viewModel.displayCount
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "DeviceCell",
            for: indexPath
        ) as! DeviceTableViewCell

        let device = viewModel.displayDevice(at: indexPath.row)

        cell.configure(device)

        return cell
    }
}


extension HomeViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        tableView.deselectRow(at: indexPath, animated: true)

        let device = viewModel.displayDevice(at: indexPath.row)
        
        self.performSegue(withIdentifier: "detail", sender: device)


    }
}

extension HomeViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.search(keyword: searchText)
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        viewModel.search(keyword: "")
        tableView.reloadData()
    }
}
