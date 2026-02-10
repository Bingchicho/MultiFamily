//
//  TintedButton.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

import UIKit

final class TintedButton: UIButton {

    override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    override var isHighlighted: Bool {
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

        // 關掉 iOS15 configuration
        if #available(iOS 15.0, *) {
            configuration = nil
        }

        // 字體
        titleLabel?.font = Typography.secondaryButton
        titleLabel?.adjustsFontForContentSizeCategory = false

        // layout
        layer.cornerRadius = 10
        clipsToBounds = true

        heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true

        updateAppearance()
    }

    private func updateAppearance() {

        let baseColor = AppTheme.current.primary

        if !isEnabled {

            backgroundColor = baseColor.withAlphaComponent(0.15)
            setTitleColor(baseColor.withAlphaComponent(0.4), for: .normal)
            layer.borderWidth = 0
            return
        }

        if isHighlighted {

            backgroundColor = baseColor.withAlphaComponent(0.25)
            setTitleColor(baseColor, for: .normal)

        } else {

            backgroundColor = baseColor.withAlphaComponent(0.12)
            setTitleColor(baseColor, for: .normal)
        }
    }
}
