//
//  HomeViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
