//
//  RegistryUpdateRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

struct RegistryUpdateRequestDTO: Encodable {

    // required（通常 API 一定要）
    let applicationID: String
    let thingName: String
    let clientToken: String

    // optional：有值才出 key
    let overwrite: Bool?
    let taskID: String?
    let status: String?
    let userName: String?

    let name: String?
    let installationNotComplete: Bool?

    let bt: LockBTDTO?
    let attributes: DeviceAttributesDTO?

    enum CodingKeys: String, CodingKey {
        case overwrite, taskID, status, userName
        case applicationID, thingName, name, installationNotComplete
        case bt, attributes
        case clientToken
    }
}

extension RegistryUpdateRequestDTO {

    /// 把 detail response 當作 update 的基底
    /// - Important: 這裡把 detail 裡有值的欄位帶入；若你想「只送被使用者改動的欄位」，
    ///   建議另外做 diff，只把改動的欄位覆寫到 patch DTO（下面我也給範例）
    init(from detail: RegistryResponseDTO) {
        self.applicationID = detail.applicationID
        self.thingName = detail.thingName
        self.clientToken = detail.clientToken

        self.overwrite = nil
        self.taskID = nil
        self.status = nil
        self.userName = nil

        self.name = detail.name
        self.installationNotComplete = detail.installationNotComplete

        self.bt = detail.bt
        self.attributes = detail.attributes
    }

    /// 你在 UI 改動後，用這個做「patch」：只覆寫你要改的欄位，其餘保持原樣
    func applying(
        overwrite: Bool? = nil,
        status: String? = nil,
        name: String? = nil,
        installationNotComplete: Bool? = nil,
        bt: LockBTDTO? = nil,
        attributes: DeviceAttributesDTO? = nil
    ) -> RegistryUpdateRequestDTO {

        RegistryUpdateRequestDTO(
            applicationID: applicationID,
            thingName: thingName,
            clientToken: clientToken,

            overwrite: overwrite ?? self.overwrite,
            taskID: taskID,
            status: status ?? self.status,
            userName: userName,

            name: name ?? self.name,
            installationNotComplete: installationNotComplete ?? self.installationNotComplete,

            bt: bt ?? self.bt,
            attributes: attributes ?? self.attributes
        )
    }
}
