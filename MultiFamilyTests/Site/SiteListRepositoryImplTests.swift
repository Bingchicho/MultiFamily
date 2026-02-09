//
//  SiteListRepositoryImplTests.swift
//  MultiFamilyTests
//
//  Created by Sunion on 2026/2/9.
//

import XCTest
import MultiFamily

final class SiteListRepositoryImplTests: XCTestCase {

    // MARK: - Success

    func test_getList_success_returns_sorted_sites() async throws {

        // given
        let apiClient = MockSiteListAPIClient()
        let factory = FakeSiteListRequestFactory()

        apiClient.response = SiteListResponseDTO(
            sites: [
                SiteDTO(
                    applicationID: "APP",
                    siteID: "2",
                    group: "group",
                    name: "Bravo",
                    node: nil
                ),
                SiteDTO(
                    applicationID: "APP",
                    siteID: "1",
                    group: "group",
                    name: "Alpha",
                    node: nil
                )
            ],
            clientToken: "TOKEN"
        )

        let sut = SiteListRepositoryImpl(
            apiClient: apiClient,
            siteListFactory: factory
        )

        // when
        let result = try await sut.getList()

        // then
        XCTAssertTrue(factory.didMakeRequest)
        XCTAssertEqual(apiClient.calledEndpoint, .getList)

        switch result {

        case .success(let sites):

            XCTAssertEqual(sites.count, 2)

            // verify sorted order
            XCTAssertEqual(sites[0].name, "Alpha")
            XCTAssertEqual(sites[1].name, "Bravo")

        case .failure:
            XCTFail("Expected success")
        }
    }

    // MARK: - Failure

    func test_getList_apiError_returns_failure() async throws {

        // given
        let apiClient = MockSiteListAPIClient()
        let factory = FakeSiteListRequestFactory()

        apiClient.shouldThrowError = true

        let sut = SiteListRepositoryImpl(
            apiClient: apiClient,
            siteListFactory: factory
        )

        // when
        let result = try await sut.getList()

        // then
        XCTAssertTrue(factory.didMakeRequest)

        switch result {

        case .success:
            XCTFail("Expected failure")

        case .failure(let message):
            XCTAssertEqual(message, L10n.Common.Error.network)
        }
    }
}
final class MockSiteListAPIClient: APIClient {

    enum CalledEndpoint {
        case getList
    }

    var calledEndpoint: CalledEndpoint?
    var response: SiteListResponseDTO!
    var shouldThrowError = false

    func request<T>(_ request: APIRequest) async throws -> T where T : Decodable {

        calledEndpoint = .getList

        if shouldThrowError {
            throw DummyError()
        }

        return response as! T
    }
}
final class FakeSiteListRequestFactory: SiteListRequestFactoryProtocol {

    private(set) var didMakeRequest = false

    func makeSiteListRequest() -> SiteListRequestDTO {

        didMakeRequest = true

        return SiteListRequestDTO(
            applicationID: "TEST_APP",
            clientToken: "TEST_DEVICE"
        )
    }
}
struct DummyError: Error {}
