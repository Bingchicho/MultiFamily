//
//  TintedButton.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//
import UIKit

final class TintedButton: UIButton {

    private var didSetup = false

    override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    override var isHighlighted: Bool {
        didSet { updateAppearance() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInitIfNeeded()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInitIfNeeded()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInitIfNeeded()
    }

    private func commonInitIfNeeded() {
        guard !didSetup else { return }
        didSetup = true

        titleLabel?.font = Typography.secondaryButton
        titleLabel?.adjustsFontForContentSizeCategory = false

        layer.cornerRadius = 10
        clipsToBounds = true

        // 避免重複加 constraint
        let h = heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        h.priority = .required
        h.isActive = true

        if #available(iOS 15.0, *) {
            // ✅ 保留 storyboard 設好的 configuration（含 image 位置、padding）
            // 只用 update handler 更新顏色
            configurationUpdateHandler = { [weak self] button in
                guard let self else { return }
                self.applyConfigurationColors(button)
            }
        }

        updateAppearance()
    }

    private func updateAppearance() {
        if #available(iOS 15.0, *) {
            setNeedsUpdateConfiguration()
        } else {
            applyLegacyColors()
        }
    }

    // MARK: - iOS15+ (Configuration)

    @available(iOS 15.0, *)
    private func applyConfigurationColors(_ button: UIButton) {
        var config = button.configuration ?? .plain() // storyboard 沒設也 OK

        let base = AppTheme.current.primary

        let bgAlpha: CGFloat
        let fgAlpha: CGFloat

        if !button.isEnabled {
            bgAlpha = 0.15
            fgAlpha = 0.40
        } else if button.isHighlighted {
            bgAlpha = 0.25
            fgAlpha = 1.0
        } else {
            bgAlpha = 0.12
            fgAlpha = 1.0
        }

        // ✅ 不改 imagePlacement / imagePadding / contentInsets（保留 storyboard 的）
        config.baseBackgroundColor = base.withAlphaComponent(bgAlpha)
        config.baseForegroundColor = base.withAlphaComponent(fgAlpha)

        button.configuration = config
    }

    // MARK: - iOS13~14 (Legacy)

    private func applyLegacyColors() {
        let base = AppTheme.current.primary

        if !isEnabled {
            backgroundColor = base.withAlphaComponent(0.15)
            setTitleColor(base.withAlphaComponent(0.4), for: .normal)
            setTitleColor(base.withAlphaComponent(0.4), for: .disabled)
            tintColor = base.withAlphaComponent(0.4)
            layer.borderWidth = 0
            return
        }

        if isHighlighted {
            backgroundColor = base.withAlphaComponent(0.25)
        } else {
            backgroundColor = base.withAlphaComponent(0.12)
        }

        setTitleColor(base, for: .normal)
        tintColor = base
        layer.borderWidth = 0
    }
}
