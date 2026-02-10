//
//  Theme.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/2.
//

import UIKit

protocol Theme {
    var primary: UIColor { get }
    var secondary: UIColor { get }
    var error: UIColor { get }
    var background: UIColor { get }
    var synced: UIColor { get }
    var unsynced: UIColor { get }
}
