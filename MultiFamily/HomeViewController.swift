//
//  HomeViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var siteButton: UIButton!
    @IBOutlet weak var accountButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
     
        setupUI()
    }
    
    private func setupUI() {
        self.title = L10n.Home.title
        siteButton.setTitle("", for: .normal)
        accountButton.setTitle("", for: .normal)
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "site",
           let vc = segue.destination as? SiteListViewController {
            vc.delegate = self
        }
    }

}


extension HomeViewController: SiteListDelegate {
    func siteListDidSelect(_ site: Site) {
        AppLogger.log(.info, category: .site, "selected site: \(site)")
    }
    
    
}
