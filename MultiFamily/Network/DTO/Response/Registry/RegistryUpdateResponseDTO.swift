//
//  RegistryUpdateResponseDTO.swift
//  MultiFamily
//
//  Created by Sunion on 2026/2/23.
//

struct RegistryUpdateResponseDTO: Decodable {
    let overwrite: Bool
    let taskID: String
    let status: String // "done" / "wait"
    let userName: String?
    let clientToken: String
}
