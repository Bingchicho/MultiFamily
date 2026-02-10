//
//  Device.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/10.
//

struct Device {

    let id: UInt16
    let name: String
    let thingName: String

    let model: String
    let group: String

    let activeMode: String
    let isResident: Bool

    let deviceRole: String

    let bt: DeviceBT?

    let gateway: Int
    let job: Int
    let ota: Int
}

struct DeviceBT {

    let uuid: String
    let key: String
    let token: String
}

extension DeviceDTO {

    func toDomain() -> Device {
        Device(
            id: deviceID,
            name: name,
            thingName: thingName,
            model: model,
            group: group,
            activeMode: activeMode,
            isResident: isResident,
            deviceRole: deviceRole,
            bt: bt?.toDomain(),
            gateway: gateway,
            job: job,
            ota: ota
        )
    }
}

extension DeviceBTDTO {

    func toDomain() -> DeviceBT {
        DeviceBT(
            uuid: uuid,
            key: key,
            token: token
        )
    }
}
