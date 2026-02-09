//
//  SiteTableViewCell.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

import UIKit

class SiteTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var titleLabel: AppLabel!
    
    private var  siteSelection = AppAssembler.siteSelectionStore.currentSite

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.style = .title
        
        if #available(iOS 14.0, *) {
            backgroundConfiguration = nil
        } else {
            // Fallback on earlier versions
        }
         backgroundColor = .clear
        contentView.backgroundColor = .systemBackground
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with site: Site) {

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
