//
//  DeviceRepositoryImplTests.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/11.
//

//
//  DeviceRepositoryImplTests.swift
//  MultiFamilyTests
//

import XCTest
import MultiFamily

final class DeviceRepositoryImplTests: XCTestCase {

    func test_fetchDevices_success_returnsSortedDevices() async throws {

        // given
        let apiClient = MockDeviceAPIClient()
        let factory = FakeDeviceRequestFactory()

        apiClient.response = DeviceListResponseDTO(
            devices: [
                DeviceDTO(
                    applicationID: "APP",
                    thingName: "2",
                    deviceID: 2,
                    activeMode: "ble",
                    model: "model",
                    group: "group",
                    name: "Device B",
                    isResident: true,
                    deviceRole: "role",
                    bt: nil,
                    gateway: 0,
                    job: 0,
                    ota: 0
                ),
                DeviceDTO(
                    applicationID: "APP",
                    thingName: "1",
                    deviceID: 1,
                    activeMode: "ble",
                    model: "model",
                    group: "group",
                    name: "Device A",
                    isResident: true,
                    deviceRole: "role",
                    bt: nil,
                    gateway: 0,
                    job: 0,
                    ota: 0
                )
            ],
            clientToken: "TOKEN"
        )

        let sut = DeviceRepositoryImpl(
            apiClient: apiClient,
            factory: factory
        )

        // when
        let devices = try await sut.fetchDevices(siteID: "SITE_ID")

        // then
        XCTAssertTrue(factory.didMakeDeviceListRequest)



        XCTAssertEqual(devices.count, 2)

        // verify sorted by name
        XCTAssertEqual(devices[0].name, "Device A")
        XCTAssertEqual(devices[1].name, "Device B")
    }

}

final class MockDeviceAPIClient: APIClient {

    enum CalledEndpoint {
        case list
    }

    var calledEndpoint: CalledEndpoint?
    var response: DeviceListResponseDTO!

    func request<T>(_ request: APIRequest) async throws -> T where T : Decodable {

        if request.path.contains("device/list") {
            calledEndpoint = .list
        }

        return response as! T
    }
}

final class FakeDeviceRequestFactory: DeviceRequestFactoryProtocol {

    private(set) var didMakeDeviceListRequest = false

    func makeDeviceListRequest(siteID: String) -> DeviceListRequestDTO {

        didMakeDeviceListRequest = true

        return DeviceListRequestDTO(
            applicationID: "TEST_APP",
            siteID: siteID,
            clientToken: "TEST_TOKEN"
        )
    }
}
