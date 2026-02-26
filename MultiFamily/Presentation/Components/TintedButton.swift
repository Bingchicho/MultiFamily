//
//  TintedButton.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//
import UIKit

final class TintedButton: UIButton {

    private var didSetup = false
    private var pressAnimator: UIViewPropertyAnimator?
    private let pressedScale: CGFloat = 0.97

    override var isEnabled: Bool {
        didSet {
            updateAppearance()
            if !isEnabled {
                pressAnimator?.stopAnimation(true)
                transform = .identity
            }
        }
    }
    
    override var isSelected: Bool {
        didSet {
            updateAppearance()
        }
    }

    override var isHighlighted: Bool {
        didSet {
            updateAppearance()
            animatePress(down: isHighlighted)
        }
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

        if !button.isEnabled {
            config.baseBackgroundColor = UIColor.clear
            config.baseForegroundColor = base.withAlphaComponent(0.4)
        } else if button.isSelected {
            config.baseBackgroundColor = base.withAlphaComponent(0.25)
            config.baseForegroundColor = base
        } else {
            // ✅ 未點擊時回到預設（透明）
            config.baseBackgroundColor = UIColor.clear
            config.baseForegroundColor = base
        }

        // ✅ 不改 imagePlacement / imagePadding / contentInsets（保留 storyboard 的）

        button.configuration = config
    }

    // MARK: - iOS13~14 (Legacy)

    private func applyLegacyColors() {
        let base = AppTheme.current.primary

        if !isEnabled {
            backgroundColor = .clear
            setTitleColor(base.withAlphaComponent(0.4), for: .normal)
            setTitleColor(base.withAlphaComponent(0.4), for: .disabled)
            tintColor = base.withAlphaComponent(0.4)
            return
        }

        if isSelected {
            backgroundColor = base.withAlphaComponent(0.25)
        } else {
            // ✅ 未點擊時恢復預設背景
            backgroundColor = .clear
        }

        setTitleColor(base, for: .normal)
        tintColor = base
    }

    // MARK: - Press animation (Apple-like tinted feel)

    private func animatePress(down: Bool) {
        // Cancel any in-flight animation to prevent jitter
        pressAnimator?.stopAnimation(true)

        let targetTransform: CGAffineTransform = down ? CGAffineTransform(scaleX: pressedScale, y: pressedScale) : .identity

        // Keep it subtle and snappy like system buttons
        let duration: TimeInterval = down ? 0.12 : 0.18

        let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 0.85) { [weak self] in
            guard let self else { return }
            self.transform = targetTransform
        }

        animator.startAnimation()
        pressAnimator = animator
    }
}
