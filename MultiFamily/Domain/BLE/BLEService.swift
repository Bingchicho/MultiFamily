//
//  BLEService.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/24.
//

import Foundation
import MFRBleSDK

/// ✅ 業務流程層：UseCase / ViewModel 只認這個
/// - 它描述「要完成什麼事情」
/// - 不描述「怎麼掃描/怎麼連線」
public protocol BLEService {
    /// Provision 流程：用 btInfo 連上去，讀出 registry 類資料
    var status: LockStatus? { get }
    func connection() async throws

    func provisionAndFetchRegistry(btInfo: ProvisionBLEInfo, addform: AddForm, siteID: String) async throws 
}
