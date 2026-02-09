//
//  ImageTextButton.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/9.
//

import UIKit

@IBDesignable
final class ImageTextButton: UIButton {

    enum LayoutStyle: Int {
        case imageLeft
        case imageRight
        case imageTop
        case imageBottom
    }

    // MARK: - Inspectable

    @IBInspectable
    var spacing: CGFloat = 8 {
        didSet { updateLayout() }
    }

    @IBInspectable
    var layoutRawValue: Int = 0 {
        didSet {
            layoutStyle = LayoutStyle(rawValue: layoutRawValue) ?? .imageLeft
        }
    }

    private var layoutStyle: LayoutStyle = .imageLeft {
        didSet { updateLayout() }
    }

    override var isEnabled: Bool {
        didSet { updateAppearance() }
    }

    // MARK: - Init

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

    override func layoutSubviews() {
        super.layoutSubviews()
        updateLayout()
    }

    // MARK: - Setup

    private func commonInit() {

        // Disable system config (iOS 15+)
        if #available(iOS 15.0, *) {
            configuration = nil
        }

        adjustsImageWhenHighlighted = false

        // Typography
        titleLabel?.font = Typography.textButton
        titleLabel?.adjustsFontForContentSizeCategory = false

        // Theme color
        tintColor = AppTheme.current.primary

        backgroundColor = .clear

        updateAppearance()
        updateLayout()
    }

    // MARK: - Appearance

    private func updateAppearance() {

        let color = isEnabled
            ? AppTheme.current.primary
            : AppTheme.current.primary.withAlphaComponent(0.4)

        setTitleColor(color, for: .normal)
        setTitleColor(color, for: .disabled)

        imageView?.tintColor = color
    }

    // MARK: - Layout

    private func updateLayout() {

        guard
            let imageView = imageView,
            let titleLabel = titleLabel
        else { return }

        let imageSize = imageView.intrinsicContentSize
        let titleSize = titleLabel.intrinsicContentSize

        switch layoutStyle {

        case .imageLeft:

            imageEdgeInsets = .zero
            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: spacing,
                bottom: 0,
                right: -spacing
            )

        case .imageRight:

            imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: titleSize.width + spacing,
                bottom: 0,
                right: -(titleSize.width + spacing)
            )

            titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -(imageSize.width),
                bottom: 0,
                right: imageSize.width
            )

        case .imageTop:

            imageEdgeInsets = UIEdgeInsets(
                top: -titleSize.height - spacing,
                left: 0,
                bottom: 0,
                right: -titleSize.width
            )

            titleEdgeInsets = UIEdgeInsets(
                top: imageSize.height + spacing,
                left: -imageSize.width,
                bottom: 0,
                right: 0
            )

        case .imageBottom:

            imageEdgeInsets = UIEdgeInsets(
                top: titleSize.height + spacing,
                left: 0,
                bottom: 0,
                right: -titleSize.width
            )

            titleEdgeInsets = UIEdgeInsets(
                top: -imageSize.height - spacing,
                left: -imageSize.width,
                bottom: 0,
                right: 0
            )
        }
    }
}
