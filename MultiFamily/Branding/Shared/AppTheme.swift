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
    var synced: UIColor { UIColor(named: "Synced")! }
    var unsynced: UIColor { UIColor(named: "Unsynced")! }
}

enum AppTheme {
    static var current: Theme = DefaultTheme()
}
