//
//  SiteTableViewCell.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

import UIKit

protocol SiteTableViewCellDelegate: AnyObject {
    func siteTableViewCell(_ cell: SiteTableViewCell, didTapEdit site: Site)
    func siteTableViewCell(_ cell: SiteTableViewCell, didTapDelete site: Site)
}

class SiteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: AppLabel!
    
    @IBOutlet weak var actionStackView: UIStackView!
    
    @IBOutlet weak var editButton: UIButton!
    
    @IBOutlet weak var deleteButton: UIButton!
    
    weak var delegate: SiteTableViewCellDelegate?
    private var currentSite: Site!
    
    private var siteSelection: Site? { AppAssembler.siteSelectionStore.currentSite }

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.style = .title
        editButton.setTitle("", for: .normal)
        deleteButton.setTitle("", for: .normal)
        editButton.tintColor = .primary
        deleteButton.tintColor = .error
        
        if #available(iOS 14.0, *) {
            backgroundConfiguration = nil
        }

        // Keep cell background clear so we can color the contentView for selection styling.
        backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        // Reset reused state
        applyDeselectedStyle()
        actionStackView.isHidden = true
        currentSite = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with site: Site) {
        currentSite = site

        titleLabel.text = site.name

        iconView.image = UIImage(systemName: "house")

        guard let siteSelection else {
            applyDeselectedStyle()
           
            return
        }

        if siteSelection.id == site.id {
            applySelectedStyle()
        } else {
            applyDeselectedStyle()
        }
        
    
    }
    
    func setUpAction(_ site: Site) {
 
        actionStackView.isHidden = !(site.userRole == .admin)
    }
    
    @IBAction private func editButtonTapped(_ sender: UIButton) {
        guard let site = currentSite else { return }
        delegate?.siteTableViewCell(self, didTapEdit: site)
    }

    @IBAction private func deleteButtonTapped(_ sender: UIButton) {
        guard let site = currentSite else { return }
        delegate?.siteTableViewCell(self, didTapDelete: site)
    }

    private func applySelectedStyle() {
        iconView.tintColor = .systemBlue
        contentView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        titleLabel.textColor = .systemBlue
    }

    private func applyDeselectedStyle() {
        iconView.tintColor = .label
        contentView.backgroundColor = .systemBackground
        titleLabel.textColor = .label
    }
    
}
