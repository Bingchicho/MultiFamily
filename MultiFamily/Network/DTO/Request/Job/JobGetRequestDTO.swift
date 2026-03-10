//
//  JobGetRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//

import Foundation

struct JobGetRequestDTO: Encodable {
    let applicationID: String
    let thingName: String
    let clientToken: String
}
