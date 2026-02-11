//
//  DetailViewController.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

import UIKit

class DetailViewController: UIViewController {
    
    
    @IBOutlet weak var timeLabel: AppLabel!
    @IBOutlet weak var syncedLabel: AppLabel!
    @IBOutlet weak var syncedImageView: UIImageView!
    @IBOutlet weak var beepLabel: AppLabel!
    @IBOutlet weak var beepTitleLabel: AppLabel!
    @IBOutlet weak var autoLockLabel: AppLabel!
    @IBOutlet weak var autoLockTitleLabel: AppLabel!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var betteryLabel: AppLabel!
    @IBOutlet weak var betteryTitleLabel: AppLabel!
    @IBOutlet weak var containerView: UIView!
    
    
    @IBOutlet weak var syncButton: PrimaryButton!
    
    @IBOutlet weak var lockUnlockButton: PrimaryButton!
    
    @IBOutlet weak var moreButton: TintedButton!
    var device: Device?
    
    @IBOutlet weak var historyButton: TintedButton!
    @IBOutlet weak var authorizedButton: TintedButton!
    @IBOutlet weak var blackButton: TintedButton!
    
 
    private var currentVC: UIViewController?

    private lazy var eventVC = EventHistoryViewController()
    private lazy var authorizedVC = AuthorizedViewController()
    private lazy var blacklistVC = BlacklistViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    private func setupUI() {
        self.title = device?.name
    }
    
    private func switchChild(to newVC: UIViewController) {

        if let currentVC {
            currentVC.willMove(toParent: nil)
            currentVC.view.removeFromSuperview()
            currentVC.removeFromParent()
        }

        addChild(newVC)

        newVC.view.frame = containerView.bounds

        containerView.addSubview(newVC.view)

        newVC.didMove(toParent: self)

        currentVC = newVC
    }
    
    private func switchTo(_ tab: DeviceTab) {

        let newVC: UIViewController

        switch tab {

        case .event:
            newVC = eventVC

        case .authorized:
            newVC = authorizedVC

        case .blacklist:
            newVC = blacklistVC
        }

        switchChild(to: newVC)
    }
    
    


    @IBAction func syncButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func lockUnlockButtonAction(_ sender: UIButton) {
    }
    @IBAction func moreButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func historyButtonAction(_ sender: UIButton) {
        switchTo(.event)
    }
    
    @IBAction func authorizedButtonAction(_ sender: UIButton) {
        switchTo(.authorized)
    }
    
    @IBAction func blackButtonAction(_ sender: UIButton) {
        switchTo(.blacklist)
    }
    
}
