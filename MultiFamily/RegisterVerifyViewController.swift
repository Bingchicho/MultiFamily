//
//  RegisterVerifyViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

import UIKit

class RegisterVerifyViewController: UIViewController {
    
    var email: String?
    var ticket: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = true

        let backItem = UIBarButtonItem(
            image: UIImage(systemName: "chevron.left"),
            style: .plain,
            target: self,
            action: #selector(backToLogin)
        )

        navigationItem.leftBarButtonItem = backItem
    }
    

    @objc private func backToLogin() {
        navigationController?.popToRootViewController(animated: true)
    }

}
