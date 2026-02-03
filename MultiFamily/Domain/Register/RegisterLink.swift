//
//  RegisterLink.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/3.
//

enum RegisterLink {
    case terms
    case privacy

    var urlString: String {
        switch self {
        case .terms:
            return L10n.termsLink
        case .privacy:
            return L10n.privacyLink
        }
    }
}
