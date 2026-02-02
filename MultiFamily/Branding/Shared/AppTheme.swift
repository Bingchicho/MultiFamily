//
//  AppTheme.swift.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/2.
//

import UIKit

struct DefaultTheme: Theme {
    var primary: UIColor { UIColor(named: "Primary")! }
    var secondary: UIColor { UIColor(named: "Secondary")! }
    var error: UIColor { UIColor(named: "Error")! }
    var background: UIColor { UIColor(named: "Background")! }
}

enum AppTheme {
    static var current: Theme = DefaultTheme()
}
