//
//  SiteListViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

import UIKit

protocol SiteListDelegate: AnyObject {
    func siteListDidSelect(_ site: Site)
}

@MainActor
final class SiteListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: AppLabel!

    weak var delegate: SiteListDelegate?

    private var viewModel: SiteListViewModel?

    private var sites: [Site] = []
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!

    private var isPresentingCreateAlert = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSheet()
        setupTable()
        bindViewModel()

   
    }
    
    private func setupUI() {
        titleLabel.text = L10n.Site.title
        titleLabel.style = .title
        closeButton.setTitle("", for: .normal)
    }
    
    private func bindViewModel() {
        
        let vm = SiteListViewModel(
            useCase: AppAssembler.makeSiteUseCase()
        )

        viewModel = vm
        
        holdLoading(animat: true)
        vm.loadSites()
        vm.onStateChange = { [weak self] state in
            guard let self else { return }
            self.render(state)
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
    
    private func render(_ state: SiteListViewState) {

        switch state {

        case .idle:
            holdLoading(animat: false)
            

        case .loading:
            holdLoading(animat: true)

        case .loaded(let sites):
            holdLoading(animat: false)
            self.sites = sites
            tableView.reloadData()

        case .error:
            holdLoading(animat: false)
            break
        case .create:
            holdLoading(animat: false)
            presentCreateSiteAlertIfNeeded()
        }
    }
    
    private func presentCreateSiteAlertIfNeeded() {
        guard isPresentingCreateAlert == false else { return }
        isPresentingCreateAlert = true

        let alert = UIAlertController(
            title: L10n.Site.Alert.title,
            message: nil,
            preferredStyle: .alert
        )

        alert.addTextField { textField in
            textField.placeholder = L10n.Site.Alert.placeholder
            textField.autocapitalizationType = .words
            textField.autocorrectionType = .no
        }

        let create = UIAlertAction(title: L10n.Common.Button.confirm, style: .default) { [weak self] _ in
            guard let self else { return }
            self.isPresentingCreateAlert = false

            let name = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard name.isEmpty == false else {
                // If empty, re-present so user can input again
                self.presentCreateSiteAlertIfNeeded()
                return
            }
            self.viewModel?.createSite(name: name)
        }

        alert.addAction(create)

        present(alert, animated: true)
    }
    
    private func setupSheet() {

        if #available(iOS 15.0, *) {
            if let sheet = sheetPresentationController {
                
                sheet.detents = [
                    .medium(),
                    .large()
                ]
                
                sheet.prefersGrabberVisible = true
                sheet.preferredCornerRadius = 24
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    private func setupTable() {

        tableView.register(
            UINib(nibName: "SiteTableViewCell", bundle: nil),
            forCellReuseIdentifier: "SiteCell"
        )

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
    }
    
    @IBAction func closeTapped() {
        isPresentingCreateAlert = false
        dismiss(animated: true)
    }

}

extension SiteListViewController: UITableViewDataSource {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {

        sites.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(
            withIdentifier: "SiteCell",
            for: indexPath
        ) as! SiteTableViewCell

        cell.configure(with: sites[indexPath.row])

        return cell
    }
}

extension SiteListViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {

        let site = sites[indexPath.row]
    
        delegate?.siteListDidSelect(site)
        viewModel?.setSelectedSite(site)
        dismiss(animated: true)
    }
}
