//
//  HistoryRequestDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/12.
//

struct HistoryRequestDTO: Encodable {

    let applicationID: String
    let id: String
    let idType: String
    let timePoint: Int64
    let maximum: Int
    let clientToken: String

}
