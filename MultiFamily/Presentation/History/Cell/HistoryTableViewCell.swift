//
//  HistoryTableViewCell.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventLabel: AppLabel!
    @IBOutlet weak var dateLabel: AppLabel!
    @IBOutlet weak var userLabel: AppLabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        eventLabel.style = .title
        dateLabel.style = .caption
        userLabel.style = .body
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with history: History) {

         eventLabel.text = history.type.displayName
         dateLabel.text = history.date.formattedString
         userLabel.text = history.from ?? "-"
     }
}


extension Date {

    var formattedString: String {

        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateStyle = .short
        formatter.timeStyle = .short

        return formatter.string(from: self)
    }
}
