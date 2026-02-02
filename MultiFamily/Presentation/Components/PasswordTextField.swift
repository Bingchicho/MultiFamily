//
//  PasswordTextField.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/2.
//

import UIKit

final class PasswordTextField: UITextField {

    private var isPasswordVisible = false
    private let toggleButton = UIButton(type: .custom)

    // MARK: - Public API

    func enablePasswordToggle() {
        setupPasswordToggle()
    }

    // MARK: - Setup

    private func setupPasswordToggle() {
        isSecureTextEntry = true

        toggleButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        toggleButton.tintColor = UIColor.darkGray.withAlphaComponent(0.6)
        toggleButton.addTarget(self, action: #selector(togglePasswordVisibility), for: .touchUpInside)

        rightView = toggleButton
        rightViewMode = .always
    }

    @objc private func togglePasswordVisibility() {
        isPasswordVisible.toggle()

        // 🔑 iOS 安全坑：切換 secure 會重置 cursor
        let currentText = text
        text = nil
        text = currentText

        isSecureTextEntry = !isPasswordVisible

        let imageName = isPasswordVisible ? "eye" : "eye.slash"
        toggleButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
}
