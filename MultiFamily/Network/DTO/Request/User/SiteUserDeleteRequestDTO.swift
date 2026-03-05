//
//  SiteUserDeleteRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/5.
//

struct SiteUserDeleteRequestDTO: Encodable {

    let applicationID: String
    let siteID: String
    let userID: String
    let clientToken: String

}
