//
//  TextButton.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/2.
//

import UIKit

final class TextButton: UIButton {

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
        // 關掉 system 預設行為
        tintColor = .clear
        adjustsImageWhenHighlighted = false
        
        // 2️⃣ 關 iOS 15+ configuration
        if #available(iOS 15.0, *) {
            configuration = nil
        }

        // 🔒 鎖死字體（不支援 Dynamic Type）
        titleLabel?.font = Typography.textButton
        titleLabel?.adjustsFontForContentSizeCategory = false

        // 外觀（純文字）
        backgroundColor = .clear
        layer.borderWidth = 0
        heightAnchor.constraint(greaterThanOrEqualToConstant: 32).isActive = true

        updateAppearance()
    }

    private func updateAppearance() {
        if isEnabled {
            setTitleColor(AppTheme.current.primary, for: .normal)
        } else {
            setTitleColor(AppTheme.current.primary.withAlphaComponent(0.4), for: .disabled)
        }
    }
}
