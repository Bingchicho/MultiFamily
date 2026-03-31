//
//  InviteUserViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/9.
//

import UIKit

final class InviteUserViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet private weak var emailTextField: UITextField!
    @IBOutlet private weak var publicTableView: UITableView!
    @IBOutlet private weak var privateTableView: UITableView!
    @IBOutlet private weak var inviteButton: UIButton!
    @IBOutlet private weak var roleButton: UIButton!
    @IBOutlet private weak var roleLabel: UILabel!
    @IBOutlet private weak var emailLabel: UILabel!
    @IBOutlet private weak var privateLabel: UILabel!
    @IBOutlet private weak var publicLabel: UILabel!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!

    // MARK: - Dependencies

    private lazy var viewModel = InviteUserViewModel(
        useCase: AppAssembler.makeUserUseCase()
    )

    // MARK: - Input

    var devices: [Device] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()

        viewModel.configure(devices: devices)
    }

    // MARK: - Setup

    private func setupUI() {

        title = "Invite User"

        publicTableView.dataSource = self
        publicTableView.delegate = self

        privateTableView.dataSource = self
        privateTableView.delegate = self

        publicTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LockCell")
        privateTableView.register(UITableViewCell.self, forCellReuseIdentifier: "LockCell")

        inviteButton.isEnabled = false
     
        emailLabel.text = L10n.Profile.Email.title
        roleLabel.text = L10n.User.Role.title
        privateLabel.text = L10n.User.Private.title
        publicLabel.text = L10n.User.Public.title
        roleButton.setTitle(L10n.Common.User.title, for: .normal)

        emailTextField.addTarget(self, action: #selector(emailChanged), for: .editingChanged)
    }

    private func bindViewModel() {

        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }

            switch state {

            case .idle:
                holdLoading(animat: false)

            case .updated:
                self.inviteButton.isEnabled = self.viewModel.isValid
                self.roleButton.setTitle(self.viewModel.selectedRole, for: .normal)
                self.publicTableView.reloadData()
                self.privateTableView.reloadData()
            case .loading:
                holdLoading(animat: true)
            case .created:
                holdLoading(animat: false)
                showSuccess()
            case .error(let error):
                holdLoading(animat: false)
                showError(error)
            }
        }
    }
    
    private func showSuccess() {
        let alert = UIAlertController(title: L10n.User.Invite.Success.title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default) { [weak self] _ in
    
            self?.performSegue(withIdentifier: "backhome", sender: nil)
        })
        present(alert, animated: true)
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: L10n.Common.Error.title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default))
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
        
        // Only disable current view interaction (avoid freezing navigation stack)
        view.isUserInteractionEnabled = !animat
    }

    // MARK: - Actions

    @objc
    private func emailChanged() {
        viewModel.updateEmail(emailTextField.text ?? "")
    }

    @IBAction private func inviteButtonTapped(_ sender: UIButton) {
        guard let siteId = AppAssembler.siteSelectionStore.currentSite?.id else { return }

        viewModel.inviteUser(
            siteId: siteId
        )
    }
    
    @IBAction private func roleButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(
            title: L10n.User.Alert.Edit.title,
            message: nil,
            preferredStyle: .actionSheet
        )

        let managerAction = UIAlertAction(title: L10n.Common.Manager.title, style: .default) { [weak self] _ in
            self?.viewModel.updateRole("Manager")
        }

        let userAction = UIAlertAction(title: L10n.Common.User.title, style: .default) { [weak self] _ in
            self?.viewModel.updateRole("User")
        }

        let cancelAction = UIAlertAction(title: L10n.Common.Button.cancel, style: .cancel)


        if let sideId = AppAssembler.siteSelectionStore.currentSite?.id,
           let role = AppAssembler.userAttributeStore.currentUser?.permissions?.filter( { $0.siteID == sideId }).first?.userRole,
           role == .admin {
            alert.addAction(managerAction)
        }
      
        alert.addAction(userAction)
        alert.addAction(cancelAction)

        if let popover = alert.popoverPresentationController {
            popover.sourceView = sender
            popover.sourceRect = sender.bounds
        }

        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension InviteUserViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if tableView == publicTableView {
            return viewModel.publicLocks.count
        }

        return viewModel.privateLocks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "LockCell", for: indexPath)

        let device: Device

        if tableView == publicTableView {
            device = viewModel.publicLocks[indexPath.row]
            cell.accessoryType = viewModel.selectedPublicLocks.contains(device.thingName) ? .checkmark : .none
        } else {
            device = viewModel.privateLocks[indexPath.row]
            cell.accessoryType = viewModel.selectedPrivateLocks.contains(device.thingName) ? .checkmark : .none
        }

        cell.textLabel?.text = device.name

        return cell
    }
}

// MARK: - UITableViewDelegate

extension InviteUserViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if tableView == publicTableView {
            let device = viewModel.publicLocks[indexPath.row]
            viewModel.togglePublicLock(device)
        } else {
            let device = viewModel.privateLocks[indexPath.row]
            viewModel.togglePrivateLock(device)
        }

        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
