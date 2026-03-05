//
//  UserViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inviteButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    

    private func setupUI() {
        inviteButton.setTitle("", for: .normal)
        inviteButton.tintColor = .primary
    }
}
