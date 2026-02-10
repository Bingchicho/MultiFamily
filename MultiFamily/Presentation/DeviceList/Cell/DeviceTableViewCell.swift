//
//  DeviceTableViewCell.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

import UIKit

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var syncButton: TintedButton!
    @IBOutlet weak var syncedLabel: AppLabel!
    @IBOutlet weak var syncedImageView: UIImageView!
  
    @IBOutlet weak var deviceNameLabel: AppLabel!
    @IBOutlet weak var iconImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        deviceNameLabel.style = .body
       
        syncedLabel.style = .caption
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(_ device: Device) {

        deviceNameLabel.text = device.name
       
        if device.job == 0 {
            syncedImageView.image = UIImage(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
            syncedImageView.tintColor = .synced
            syncButton.isHidden = true
        } else {
            syncedImageView.image = UIImage(systemName: "exclamationmark.arrow.trianglehead.2.clockwise.rotate.90")
            syncedImageView.tintColor = .unsynced
            syncButton.isHidden = false
            syncButton.isEnabled = true
        }
    }
    
    @IBAction func syncButtonAction(_ sender: UIButton) {
    }
}
