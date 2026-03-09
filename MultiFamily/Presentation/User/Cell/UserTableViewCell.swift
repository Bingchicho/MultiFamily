//
//  UserCell.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/6.
//

import UIKit

protocol UserCellDelegate: AnyObject {
    func userCell(_ cell: UserTableViewCell, didTapEdit user: User)
    func userCell(_ cell: UserTableViewCell, didTapRemove user: User)
}

final class UserTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: AppLabel!
    @IBOutlet private weak var editButton: UIButton!
    @IBOutlet private weak var removeButton: UIButton!
    @IBOutlet private weak var roleLabel: AppLabel!

    weak var delegate: UserCellDelegate?

    private var currentUser: User?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentUser = nil
        titleLabel.text = nil
    }

    private func setupUI() {
        selectionStyle = .none

        titleLabel.numberOfLines = 0
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.style = .body
        
        roleLabel.numberOfLines = 0
        roleLabel.lineBreakMode = .byWordWrapping
        roleLabel.style = .caption
        roleLabel.textColor = .secondary

        editButton.setTitle("", for: .normal)
        removeButton.setTitle("", for: .normal)

        editButton.tintColor = .primary
        removeButton.tintColor = .error

        if #available(iOS 15.0, *) {
            editButton.configuration = nil
            removeButton.configuration = nil
        }
    }

    func configure(with user: User) {
        currentUser = user
        titleLabel.text = user.name.isEmpty ? user.email : user.name
        
        if let sideId = AppAssembler.siteSelectionStore.currentSite?.id,
           let permission = user.permission.first(where: { $0.siteID == sideId }) {
            roleLabel.text = permission.userRole?.rawValue
            editButton.isHidden = permission.userRole == .user
        } else {
            roleLabel.text = nil
            editButton.isHidden = true
        }
     
  
    }

    @IBAction private func editButtonTapped(_ sender: UIButton) {
        guard let currentUser else { return }
        delegate?.userCell(self, didTapEdit: currentUser)
    }

    @IBAction private func removeButtonTapped(_ sender: UIButton) {
        guard let currentUser else { return }
        delegate?.userCell(self, didTapRemove: currentUser)
    }
}
