//
//  UserViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

import UIKit

@MainActor
final class UserViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var inviteButton: UIButton!

    private lazy var viewModel = UserViewModel(
        useCase: AppAssembler.makeUserUseCase()
    )

    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    var devices: [Device] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.load()
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
        self.title = L10n.User.title
        inviteButton.setTitle("", for: .normal)
        inviteButton.tintColor = .primary

        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()


        if #available(iOS 15.0, *) {
            tableView.sectionHeaderTopPadding = 0
        }
        

   
        tableView.register(
            UINib(nibName: "InviteUserTableViewCell", bundle: nil),
            forCellReuseIdentifier: "InviteUserCell"
        )

        tableView.register(
            UINib(nibName: "UserTableViewCell", bundle: nil),
            forCellReuseIdentifier: "UserCell"
        )
    }

    private func bindViewModel() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            render(state)
        }
    }

    private func render(_ state: UserViewState) {
        switch state {

        case .idle:
            holdLoading(animat: false)

        case .loading:
            holdLoading(animat: true)

        case .loaded:
            holdLoading(animat: false)
            tableView.reloadData()

        case .error(let message):
            holdLoading(animat: false)
            let alert = UIAlertController(
                title: L10n.Common.Error.title,
                message: message,
                preferredStyle: .alert
            )
            alert.addAction(
                UIAlertAction(
                    title: L10n.Common.Button.confirm,
                    style: .default
                )
            )
            present(alert, animated: true)
        case .option:
            holdLoading(animat: false)

            let alert = UIAlertController(
                title: nil,
                message: L10n.User.Alert.Invite.Resend.success,
                preferredStyle: .alert
            )

            alert.addAction(
                UIAlertAction(
                    title: L10n.Common.Button.confirm,
                    style: .default
                )
            )

            present(alert, animated: true)
        }
    }

    @IBAction private func inviteButtonAction(_ sender: UIButton) {
        // TODO: push invite page
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if segue.identifier == "invite",
           let vc = segue.destination as? InviteUserViewController {
            vc.devices = devices
        }
    }
}

// MARK: - UITableViewDataSource

extension UserViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.sections.count
    }

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        viewModel.sections[section].numberOfRows
    }

    func tableView(
        _ tableView: UITableView,
        titleForHeaderInSection section: Int
    ) -> String? {
        viewModel.sections[section].title
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        switch viewModel.sections[indexPath.section] {

        case .inviteUsers(let inviteUsers):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "InviteUserCell",
                for: indexPath
            ) as! InviteUserTableViewCell

            let inviteUser = inviteUsers[indexPath.row]
            cell.delegate = self
            cell.configure(with: inviteUser)

            return cell

        case .users(let users):
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "UserCell",
                for: indexPath
            ) as! UserTableViewCell

            let user = users[indexPath.row]
            cell.delegate = self
            cell.configure(with: user)

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension UserViewController: UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)

        switch viewModel.sections[indexPath.section] {

        case .inviteUsers(let inviteUsers):
            let inviteUser = inviteUsers[indexPath.row]
            print("invite user tapped: \(inviteUser.email)")

        case .users(let users):
            let user = users[indexPath.row]
            print("user tapped: \(user.email)")
        }
    }
}

extension UserViewController: InviteUserCellDelegate {

    func inviteUserCell(_ cell: InviteUserTableViewCell, didTapResend inviteUser: InviteUser) {
        let alert = UIAlertController(
            title: L10n.User.Alert.Invite.Resend.title(inviteUser.email),
            message: inviteUser.email,
            preferredStyle: .alert
        )

        let resendAction = UIAlertAction(
            title: L10n.Common.Button.confirm,
            style: .default
        ) { [weak self] _ in
            self?.viewModel.inviteResend(code: inviteUser.inviteCode)
        }

        let cancelAction = UIAlertAction(
            title: L10n.Common.Button.cancel,
            style: .cancel
        )

        alert.addAction(resendAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    func inviteUserCell(_ cell: InviteUserTableViewCell, didTapDelete inviteUser: InviteUser) {
        let alert = UIAlertController(
            title: L10n.User.Alert.Invite.Delete.title(inviteUser.email),
            message: "",
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(
            title: L10n.User.Alert.Button.Delete.title,
            style: .destructive
        ) { [weak self] _ in
            self?.viewModel.inviteDelete(code: inviteUser.inviteCode)
        }

        let cancelAction = UIAlertAction(
            title: L10n.Common.Button.cancel,
            style: .cancel
        )

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
}

extension UserViewController: UserCellDelegate {

    func userCell(_ cell: UserTableViewCell, didTapEdit user: User) {

        let selfRole = AppAssembler.userAttributeStore.currentUser?
            .permissions?
            .first?
            .userRole ?? .user

        var availableRoles: [UserRole] = []

        switch selfRole {
        case .admin:
            availableRoles = [.manager, .user]
        case .manager:
            availableRoles = [.user]
        case .user:
            availableRoles = []
        }

        // Give the alert extra vertical space only when role selector is needed.
        let message = availableRoles.count > 1 ? "\n\n\n" : nil

        
        let alert = UIAlertController(
            title: L10n.User.Alert.Edit.title,
            message: message,
            preferredStyle: .alert
        )

        var roleSegment: UISegmentedControl?
        
        if availableRoles.count > 1 {
            let segment = UISegmentedControl(items: availableRoles.map { $0.rawValue })
            
            if let sideId = AppAssembler.siteSelectionStore.currentSite?.id,
               let permission = user.permission.first(where: { $0.siteID == sideId }),
               let index = availableRoles.firstIndex(of: permission.userRole ?? .user) {
                segment.selectedSegmentIndex = index
            } else {
                segment.selectedSegmentIndex = 1
            }
            

            segment.translatesAutoresizingMaskIntoConstraints = false
            
 
            
            alert.view.addSubview(segment)
            
            NSLayoutConstraint.activate([
                segment.leadingAnchor.constraint(equalTo: alert.view.layoutMarginsGuide.leadingAnchor),
                segment.trailingAnchor.constraint(equalTo: alert.view.layoutMarginsGuide.trailingAnchor),
                segment.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 82),
                segment.heightAnchor.constraint(equalToConstant: 30)
            ])
      
            roleSegment = segment
        }

        let confirmAction = UIAlertAction(
            title: L10n.Common.Button.confirm,
            style: .default
        ) { [weak self] _ in

            let selectedRole: UserRole
            if let roleSegment, availableRoles.indices.contains(roleSegment.selectedSegmentIndex) {
                selectedRole = availableRoles[roleSegment.selectedSegmentIndex]
            } else {
                // manager only has `.user`, or fallback to original role if available.
                selectedRole = .user
            }

            guard let siteId = AppAssembler.siteSelectionStore.currentSite?.id else { return }

         
            self?.viewModel.update(
                siteId: siteId,
                userId: user.id,
                role: selectedRole
            )
        }

        let cancelAction = UIAlertAction(
            title: L10n.Common.Button.cancel,
            style: .cancel
        )

        alert.addAction(confirmAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func userCell(_ cell: UserTableViewCell, didTapRemove user: User) {
        let alert = UIAlertController(
            title: L10n.User.Alert.Delete.title(user.name),
            message: nil,
            preferredStyle: .alert
        )

        let deleteAction = UIAlertAction(
            title: L10n.User.Alert.Button.Delete.title,
            style: .destructive
        ) { [weak self] _ in
            guard let sideId = AppAssembler.siteSelectionStore.currentSite?.id else { return }
            print("remove user: \(user.email)")
            // self?.viewModel.removeUser(id: user.id)
            _ = self?.viewModel.delete(siteId: sideId, userId: user.id)
        }

        let cancelAction = UIAlertAction(
            title: L10n.Common.Button.cancel,
            style: .cancel
        )

        alert.addAction(deleteAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}
