//
//  InviteUserTableViewCell.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/6.
//


import UIKit

protocol InviteUserCellDelegate: AnyObject {
    func inviteUserCell(_ cell: InviteUserTableViewCell, didTapResend inviteUser: InviteUser)
    func inviteUserCell(_ cell: InviteUserTableViewCell, didTapDelete inviteUser: InviteUser)
}

final class InviteUserTableViewCell: UITableViewCell {

    @IBOutlet private weak var titleLabel: AppLabel!
    @IBOutlet private weak var resendButton: UIButton!
    @IBOutlet private weak var deleteButton: UIButton!

    @IBOutlet private weak var roleLabel: AppLabel!
    weak var delegate: InviteUserCellDelegate?

    private var currentInviteUser: InviteUser?

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        currentInviteUser = nil
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

        resendButton.setTitle("", for: .normal)
        deleteButton.setTitle("", for: .normal)

        resendButton.tintColor = .primary
        deleteButton.tintColor = .error

        if #available(iOS 15.0, *) {
            resendButton.configuration = nil
            deleteButton.configuration = nil
        }
    }

    func configure(with inviteUser: InviteUser) {
        currentInviteUser = inviteUser
        titleLabel.text = inviteUser.email
        roleLabel.text = inviteUser.role.rawValue
    }

    @IBAction private func resendButtonTapped(_ sender: UIButton) {
        guard let currentInviteUser else { return }
        delegate?.inviteUserCell(self, didTapResend: currentInviteUser)
    }

    @IBAction private func deleteButtonTapped(_ sender: UIButton) {
        guard let currentInviteUser else { return }
        delegate?.inviteUserCell(self, didTapDelete: currentInviteUser)
    }
}
