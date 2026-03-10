//
//  JobCreateResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/3/10.
//

import Foundation

struct JobCreateResponseDTO: Decodable {
    let jobID: String
    let clientToken: String
}
