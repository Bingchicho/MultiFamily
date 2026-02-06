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
    

    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.style = .title
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with site: Site) {

        titleLabel.text = site.name


        iconView.image = UIImage(systemName: "house")
    }
    
}
