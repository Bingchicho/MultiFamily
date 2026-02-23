//
//  AppLabel.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/2.
//

import UIKit

final class AppLabel: UILabel {

    enum Style {
        case title
        case body
        case secondary
        case caption
    }

    var style: Style = .body {
        didSet { applyStyle() }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        adjustsFontForContentSizeCategory = false
        applyStyle()
    }

    private func applyStyle() {
        switch style {
        case .title:
            font = Typography.title
            

        case .body:
            font = Typography.body

        case .secondary:
            font = Typography.secondary

        case .caption:
            font = Typography.caption
        }
    }
}
