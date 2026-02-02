//
//  PrimaryButton.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/2.
//

import UIKit

final class PrimaryButton: UIButton {

    override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        // 關掉 system 行為
        tintColor = .clear
        adjustsImageWhenHighlighted = false
        
        // 2️⃣ 關 iOS 15+ configuration
         if #available(iOS 15.0, *) {
             configuration = nil
         }

        // 🔒 鎖死字體（關 Dynamic Type）
        titleLabel?.font = Typography.primaryButton
        titleLabel?.adjustsFontForContentSizeCategory = false

        // 外觀
        layer.cornerRadius = 24
        clipsToBounds = true
        heightAnchor.constraint(equalToConstant: 48).isActive = true

        updateAppearance()
    }

    private func updateAppearance() {
        if isEnabled {
            backgroundColor = AppTheme.current.primary
            setTitleColor(.white, for: .normal)
        } else {
            backgroundColor = AppTheme.current.primary.withAlphaComponent(0.4)
            setTitleColor(.lightGray, for: .disabled)
        }
    }
}
