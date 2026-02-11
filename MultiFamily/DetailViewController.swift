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
    
    private lazy var viewModel =
    DetailViewModel(
        useCase: AppAssembler.makeDetailUseCase()
    )
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loadingBackground: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    private func holdLoading(animat: Bool) {

        if animat {
            loadingIndicator.startAnimating()
        } else {
            loadingIndicator.stopAnimating()
        }

        loadingIndicator.isHidden = !animat
        loadingBackground.isHidden = !animat

        // Only disable current screen interaction (avoid navigation freeze)
        view.isUserInteractionEnabled = !animat
    }
    
    private func bind() {
        viewModel.onStateChange = { [weak self] state in
            guard let self else { return }
            self.render(state)
        }
        
        if let thingName = device?.thingName {
            holdLoading(animat: true)
            viewModel.load(thingName: thingName)
        }
    }
    
    private func render(
        _ state: DetailViewState
    ) {
        
        switch state {
            
        case .loading:
           holdLoading(animat: true)
            
        case .loaded(let detail):
            setupData(value: detail)
            holdLoading(animat: false)
        case .error(let message):
            holdLoading(animat: false)
            showError(message)
            AppLogger.log(.error, category: .detail, message)
        default:
            break
            
        }
        
    }
    
    private func showError(_ message: String) {
        let alert = UIAlertController(
            title: L10n.Common.Error.title,
            message: message,
            preferredStyle: .alert
        )
    
        alert.addAction(UIAlertAction(title: L10n.Common.Button.confirm, style: .default, handler: { _ in
            self.navigationController?.popViewController(animated: true)
        }))
        present(alert, animated: true)
    }
    
    
    private func setupUI() {
        self.title = device?.name
        betteryTitleLabel.style = .caption
        betteryLabel.style = .caption
        autoLockTitleLabel.style = .caption
        autoLockLabel.style = .caption
        beepTitleLabel.style = .caption
        beepLabel.style = .caption
        timeLabel.style = .caption
        settingButton.setTitle("", for: .normal)
        
        if device?.job == 0 {
            syncedImageView.image = UIImage(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
            syncedImageView.tintColor = .synced
            syncedLabel.text = L10n.Home.Synced.title
            syncedLabel.textColor = .synced
        } else {
            syncedImageView.image = UIImage(systemName: "exclamationmark.arrow.trianglehead.2.clockwise.rotate.90")
            syncedImageView.tintColor = .unsynced
            syncedLabel.text = L10n.Home.Unsynced.title
            syncedLabel.textColor = .unsynced
        }
        
    }
    
    private func setupData(value: Detail) {
        betteryLabel.text = "\(value.battery)%"
        autoLockLabel.text = value.autoLock ? "\(value.autoLockDelay)S" : "OFF"
        beepLabel.text = value.beep ? "ON" : "OFF"
        timeLabel.text = "\(value.updateAt)"
        
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
