//
//  SiteUpdateRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/4.
//

struct SiteUpdateRequestDTO: Encodable {

    let applicationID: String
    let siteID: String
    let name: String
    let clientToken: String

}
