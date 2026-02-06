//
//  SiteListResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/6.
//

struct SiteListResponseDTO: Decodable {

    let sites: [SiteDTO]
    let clientToken: String

    enum CodingKeys: String, CodingKey {
        case sites
        case clientToken
    }
}

struct SiteDTO: Decodable {

    let applicationID: String
    let siteID: String
    let group: String
    let name: String
    let node: Bool?

    enum CodingKeys: String, CodingKey {
        case applicationID
        case siteID
        case group
        case name
        case node
    }
}


extension SiteDTO {

    func toDomain() -> Site {

        Site(
            id: siteID,
            name: name,
        )
    }
}
